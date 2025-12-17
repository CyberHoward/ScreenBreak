//
//  OnboardingViewModel.swift
//  ScreenBreak
//
//  ViewModel for onboarding flow
//

import Foundation
import FamilyControls
import Observation

@Observable
@MainActor
final class OnboardingViewModel {
    // Services
    private let authService = AuthorizationService.shared
    private let shieldService = ShieldManagementService.shared
    private let storage = AppGroupStorage.shared
    
    // Onboarding state
    var currentStep: OnboardingStep = .welcome
    var isLoading = false
    var errorMessage: String?
    
    // User inputs
    var motivation: String = ""
    var pactDuration: Int = 14
    var selectedApps = FamilyActivitySelection()
    var rules = PactRules.defaultRules
    
    // Authorization status
    var isAuthorized = false
    
    enum OnboardingStep: Int, CaseIterable {
        case welcome = 0
        case motivation
        case pactConfiguration
        case shieldedApps
        case confirmation
        case completed
    }
    
    // MARK: - Navigation
    
    func nextStep() {
        guard let next = OnboardingStep(rawValue: currentStep.rawValue + 1) else { return }
        currentStep = next
    }
    
    func previousStep() {
        guard let previous = OnboardingStep(rawValue: currentStep.rawValue - 1),
              currentStep != .welcome else { return }
        currentStep = previous
    }
    
    var canProceed: Bool {
        switch currentStep {
        case .welcome:
            return true
        case .motivation:
            return !motivation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .pactConfiguration:
            return rules.isValid
        case .shieldedApps:
            return !selectedApps.applicationTokens.isEmpty || !selectedApps.categoryTokens.isEmpty
        case .confirmation:
            return true
        case .completed:
            return false
        }
    }
    
    // MARK: - Authorization
    
    func requestAuthorization() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await authService.requestPermissions()
            isAuthorized = true
        } catch {
            errorMessage = "Failed to get authorization: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Create Pact
    
    func createPact() async throws {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        // Create pact
        let pact = Pact.create(
            duration: pactDuration,
            motivation: motivation,
            rules: rules
        )
        
        // Save pact
        try storage.save(pact, forKey: AppGroupStorage.Keys.activePact)
        
        // Activate shield
        shieldService.activateShield(for: selectedApps)
        
        // Move to completed
        currentStep = .completed
    }
    
    // MARK: - Preset Configurations
    
    func selectPreset(_ preset: PactPreset) {
        pactDuration = preset.durationDays
        rules = preset.rules
    }
    
    enum PactPreset {
        case weekIntro
        case twoWeekStandard
        case monthChallenge
        
        var durationDays: Int {
            switch self {
            case .weekIntro: return 7
            case .twoWeekStandard: return 14
            case .monthChallenge: return 30
            }
        }
        
        var rules: PactRules {
            switch self {
            case .weekIntro:
                return PactRules(
                    dailyLimitMinutes: 45,
                    sessionLimitMinutes: 15,
                    strictness: .gentle,
                    quietHours: nil
                )
            case .twoWeekStandard:
                return PactRules(
                    dailyLimitMinutes: 30,
                    sessionLimitMinutes: 10,
                    strictness: .balanced,
                    quietHours: nil
                )
            case .monthChallenge:
                return PactRules(
                    dailyLimitMinutes: 20,
                    sessionLimitMinutes: 10,
                    strictness: .strict,
                    quietHours: PactRules.QuietHours(startHour: 22, endHour: 7)
                )
            }
        }
        
        var title: String {
            switch self {
            case .weekIntro: return "7-Day Intro"
            case .twoWeekStandard: return "14-Day Standard"
            case .monthChallenge: return "30-Day Challenge"
            }
        }
        
        var description: String {
            switch self {
            case .weekIntro: return "Gentle start with 45 min/day"
            case .twoWeekStandard: return "Balanced approach with 30 min/day"
            case .monthChallenge: return "Strict mode with 20 min/day + quiet hours"
            }
        }
    }
}
