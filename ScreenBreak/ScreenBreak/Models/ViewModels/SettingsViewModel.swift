//
//  SettingsViewModel.swift
//  ScreenBreak
//
//  ViewModel for settings management
//

import Foundation
import FamilyControls
import ManagedSettings
import Observation

@Observable
@MainActor
final class SettingsViewModel {
    private let storage = AppGroupStorage.shared
    private let shieldService = ShieldManagementService.shared
    private let authService = AuthorizationService.shared
    
    var activePact: Pact?
    var shieldedApps: AppSelection
    var isLoading = false
    var errorMessage: String?
    
    init() {
        activePact = try? storage.load(Pact.self, forKey: AppGroupStorage.Keys.activePact)
        shieldedApps = shieldService.shieldedApps
    }
    
    // MARK: - App Management
    
    func updateShieldedApps(_ selection: FamilyActivitySelection) {
        shieldService.activateShield(for: selection)
        shieldedApps = AppSelection(from: selection)
    }
    
    func removeAllShields() {
        shieldService.deactivateShield()
        shieldedApps = AppSelection()
    }
    
    // MARK: - Pact Management
    
    func endPact() async {
        isLoading = true
        errorMessage = nil
        
        // Clear pact
        storage.remove(forKey: AppGroupStorage.Keys.activePact)
        activePact = nil
        
        // Remove shields
        removeAllShields()
        
        isLoading = false
    }
    
    func updatePactRules(_ rules: PactRules) throws {
        guard var pact = activePact else {
            throw SettingsError.noPactActive
        }
        
        pact.rules = rules
        try storage.save(pact, forKey: AppGroupStorage.Keys.activePact)
        activePact = pact
    }
    
    // MARK: - Authorization
    
    var authorizationStatus: String {
        switch authService.checkAuthorizationStatus() {
        case .notDetermined:
            return "Not Determined"
        case .denied:
            return "Denied"
        case .approved:
            return "Approved"
        @unknown default:
            return "Unknown"
        }
    }
    
    var isAuthorized: Bool {
        authService.isAuthorized
    }
    
    enum SettingsError: LocalizedError {
        case noPactActive
        
        var errorDescription: String? {
            switch self {
            case .noPactActive:
                return "No active pact to update"
            }
        }
    }
}
