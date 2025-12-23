//
//  HomeViewModel.swift
//  ScreenBreak
//
//  ViewModel for the home dashboard
//

import Foundation
import Observation

@Observable
@MainActor
final class HomeViewModel {
    private let storage = AppGroupStorage.shared
    private let shieldService = ShieldManagementService.shared
    
    // State
    var activePact: Pact?
    var todayAttempts: [Attempt] = []
    var activeSessions: [Session] = []
    var isLoading = false
    
    init() {
        loadData()
    }
    
    // MARK: - Data Loading
    
    func loadData() {
        activePact = try? storage.load(Pact.self, forKey: AppGroupStorage.Keys.activePact)
        
        if let attempts = try? storage.load([Attempt].self, forKey: AppGroupStorage.Keys.todayAttempts) {
            todayAttempts = attempts.today
        }
        
        activeSessions = shieldService.activeSessions
    }
    
    func refresh() {
        loadData()
    }
    
    // MARK: - Computed Properties
    
    var hasPact: Bool {
        activePact != nil
    }
    
    var pactProgress: Double {
        activePact?.progressPercentage ?? 0
    }
    
    var currentDay: Int {
        activePact?.currentDay ?? 0
    }
    
    var totalDays: Int {
        activePact?.durationDays ?? 0
    }
    
    var streak: Int {
        activePact?.streak ?? 0
    }
    
    var todayAttemptsCount: Int {
        todayAttempts.count
    }
    
    var todaySuccessfulAttempts: Int {
        todayAttempts.todaySuccessCount
    }
    
    var todayDeniedAttempts: Int {
        todayAttempts.todayDeniedCount
    }
    
    var todayMinutesUsed: Int {
        todayAttempts.todayMinutesGranted
    }
    
    var dailyLimit: Int {
        activePact?.rules.dailyLimitMinutes ?? 0
    }
    
    var minutesRemaining: Int {
        max(0, dailyLimit - todayMinutesUsed)
    }
    
    var usagePercentage: Double {
        guard dailyLimit > 0 else { return 0 }
        return min(1.0, Double(todayMinutesUsed) / Double(dailyLimit))
    }
    
    var motivation: String {
        activePact?.motivation ?? ""
    }
}
