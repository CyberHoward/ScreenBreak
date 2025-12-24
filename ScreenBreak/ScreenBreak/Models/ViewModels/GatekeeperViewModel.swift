//
//  GatekeeperViewModel.swift
//  ScreenBreak
//
//  ViewModel for the AI Gatekeeper flow
//

import Foundation
import FamilyControls
import ManagedSettings
import Observation

@Observable
@MainActor
final class GatekeeperViewModel {
    // Services
    private let aiService = GatekeeperAIService()
    private let shieldService = ShieldManagementService.shared
    private let storage = AppGroupStorage.shared
    
    // State
    var isLoading = false
    var errorMessage: String?
    var userIntent: String = ""
    var selectedApp: ApplicationToken?
    var selectedAppName: String = ""
    
    // Current decision
    var currentDecision: GatekeeperAIService.GatekeeperDecision?
    
    // Pact data
    var activePact: Pact?
    var todayAttempts: [Attempt] = []
    
    // Quick intent options
    let quickIntents = [
        "Reply to messages",
        "Post something",
        "Check notifications",
        "Look something up"
    ]
    
    init() {
        loadActivePact()
        loadTodayAttempts()
    }
    
    // MARK: - Request Access Flow
    
    func requestAccess(for appToken: ApplicationToken, appName: String) async {
        selectedApp = appToken
        selectedAppName = appName
        userIntent = ""
        currentDecision = nil
        errorMessage = nil
    }
    
    func submitIntent(_ intent: String) async {
        guard let appToken = selectedApp,
              let pact = activePact else {
            errorMessage = "No active pact found"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let context = GatekeeperAIService.SessionContext(
                pact: pact,
                appName: selectedAppName,
                todayUsageMinutes: calculateTodayUsage(),
                recentAttempts: todayAttempts.count,
                currentHour: Calendar.current.component(.hour, from: Date()),
                currentMinute: Calendar.current.component(.minute, from: Date())
            )
            
            let decision = try await aiService.evaluateIntent(
                intent: intent,
                appName: selectedAppName,
                context: context
            )
            
            currentDecision = decision
            
            // Log the attempt
            logAttempt(appToken: appToken, intent: intent, decision: decision)
            
            // Handle decision
            switch decision {
            case .allow(let minutes, _):
                grantAccess(to: appToken, minutes: minutes, intent: intent, decision: decision)
                
            case .deny, .followUp:
                // Just update UI with the decision
                break
            }
            
        } catch {
            errorMessage = "Failed to evaluate intent: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func useQuickIntent(_ intent: String) async {
        userIntent = intent
        await submitIntent(intent)
    }
    
    // MARK: - Private Methods
    
    private func grantAccess(
        to appToken: ApplicationToken,
        minutes: Int,
        intent: String,
        decision: GatekeeperAIService.GatekeeperDecision
    ) {
        // Remove app from shield temporarily
        shieldService.grantTemporaryAccess(to: appToken, minutes: minutes)
        
        // Create session
        if case .allow(_, let message) = decision {
            _ = shieldService.createSession(
                appToken: appToken,
                timeAllowedMinutes: minutes,
                intent: intent,
                aiDecision: message
            )
        }
    }
    
    private func logAttempt(
        appToken: ApplicationToken,
        intent: String,
        decision: GatekeeperAIService.GatekeeperDecision
    ) {
        let encoder = PropertyListEncoder()
        let appTokenData = try! encoder.encode(appToken)
        
        let attemptDecision: Attempt.Decision
        let reason: String
        let minutesGranted: Int?
        
        switch decision {
        case .allow(let minutes, let message):
            attemptDecision = .allowed
            reason = message
            minutesGranted = minutes
        case .deny(let denyReason, _):
            attemptDecision = .denied
            reason = denyReason
            minutesGranted = nil
        case .followUp(let question):
            // Don't log follow-up questions as attempts yet
            return
        }
        
        let attempt = Attempt(
            appTokenData: appTokenData,
            intent: intent,
            decision: attemptDecision,
            reason: reason,
            minutesGranted: minutesGranted
        )
        
        todayAttempts.append(attempt)
        saveTodayAttempts()
    }
    
    private func calculateTodayUsage() -> Int {
        return todayAttempts.todayMinutesGranted
    }
    
    private func loadActivePact() {
        activePact = try? storage.load(Pact.self, forKey: AppGroupStorage.Keys.activePact)
    }
    
    private func loadTodayAttempts() {
        if let attempts = try? storage.load([Attempt].self, forKey: AppGroupStorage.Keys.todayAttempts) {
            todayAttempts = attempts.today
        }
    }
    
    private func saveTodayAttempts() {
        try? storage.save(todayAttempts, forKey: AppGroupStorage.Keys.todayAttempts)
    }
    
    func reset() {
        selectedApp = nil
        selectedAppName = ""
        userIntent = ""
        currentDecision = nil
        errorMessage = nil
    }
}
