//
//  ShieldManagementService.swift
//  ScreenBreak
//
//  Service for managing app shields and temporary access
//

import Foundation
import FamilyControls
import ManagedSettings

final class ShieldManagementService: ObservableObject {
    static let shared = ShieldManagementService()
    
    private let store: ManagedSettingsStore
    private let storage = AppGroupStorage.shared
    
    @Published private(set) var shieldedApps: AppSelection = AppSelection()
    @Published private(set) var activeSessions: [Session] = []
    
    private init() {
        // Use a named store to avoid conflicts
        self.store = ManagedSettingsStore(named: ManagedSettingsStore.Name("ScreenBreakStore"))
        loadShieldedApps()
        loadActiveSessions()
    }
    
    // MARK: - Shield Configuration
    
    /// Activate shield for selected apps
    func activateShield(for selection: FamilyActivitySelection) {
        let appSelection = AppSelection(from: selection)
        shieldedApps = appSelection
        
        // Save to App Group for extension access
        try? storage.save(appSelection, forKey: AppGroupStorage.Keys.shieldedApps)
        
        // Apply shield
        applyShield()
    }
    
    /// Deactivate all shields
    func deactivateShield() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        
        shieldedApps = AppSelection()
        try? storage.save(shieldedApps, forKey: AppGroupStorage.Keys.shieldedApps)
    }
    
    /// Grant temporary access to a specific app
    func grantTemporaryAccess(to appToken: ApplicationToken, minutes: Int) {
        // Remove the app from the shield temporarily
        var currentSelection = shieldedApps.toFamilyActivitySelection()
        
        // Remove this specific token
        currentSelection.applicationTokens.remove(appToken)
        
        // Apply updated shield (without this app)
        store.shield.applications = currentSelection.applicationTokens.isEmpty ? nil : currentSelection.applicationTokens
        store.shield.applicationCategories = currentSelection.categoryTokens.isEmpty
            ? nil
            : ShieldSettings.ActivityCategoryPolicy.specific(currentSelection.categoryTokens)
        
        // Schedule to re-apply shield after time expires
        scheduleShieldReapplication(for: appToken, after: minutes)
    }
    
    /// Revoke temporary access and re-apply shield
    func revokeTemporaryAccess(to appToken: ApplicationToken) {
        // Re-apply full shield
        applyShield()
    }
    
    // MARK: - Session Management
    
    /// Create and track a new session
    func createSession(
        appToken: ApplicationToken,
        timeAllowedMinutes: Int,
        intent: String,
        aiDecision: String
    ) -> Session {
        let session = Session(
            appToken: appToken,
            timeAllowedMinutes: timeAllowedMinutes,
            intent: intent,
            aiDecision: aiDecision
        )
        
        activeSessions.append(session)
        saveActiveSessions()
        
        return session
    }
    
    /// End a session
    func endSession(_ sessionId: UUID) {
        guard let index = activeSessions.firstIndex(where: { $0.id == sessionId }) else { return }
        
        var session = activeSessions[index]
        session.end()
        activeSessions[index] = session
        
        // Re-apply shield for the app
        if let appToken = session.getApplicationToken() {
            revokeTemporaryAccess(to: appToken)
        }
        
        saveActiveSessions()
    }
    
    /// Check for expired sessions and clean them up
    func checkExpiredSessions() {
        let expiredSessionIds = activeSessions.filter { $0.hasExpired }.map { $0.id }
        
        for sessionId in expiredSessionIds {
            endSession(sessionId)
        }
    }
    
    /// Get active session for a specific app
    func getActiveSession(for appToken: ApplicationToken) -> Session? {
        // Convert token to data for comparison
        guard let tokenData = try? NSKeyedArchiver.archivedData(withRootObject: appToken, requiringSecureCoding: true) else {
            return nil
        }
        
        return activeSessions.first { session in
            session.isActive && session.appTokenData == tokenData && !session.hasExpired
        }
    }
    
    // MARK: - Private Methods
    
    private func applyShield() {
        let selection = shieldedApps.toFamilyActivitySelection()
        
        store.shield.applications = selection.applicationTokens.isEmpty ? nil : selection.applicationTokens
        store.shield.applicationCategories = selection.categoryTokens.isEmpty
            ? nil
            : ShieldSettings.ActivityCategoryPolicy.specific(selection.categoryTokens)
    }
    
    private func scheduleShieldReapplication(for appToken: ApplicationToken, after minutes: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(minutes * 60)) { [weak self] in
            self?.revokeTemporaryAccess(to: appToken)
        }
    }
    
    private func loadShieldedApps() {
        if let saved = try? storage.load(AppSelection.self, forKey: AppGroupStorage.Keys.shieldedApps) {
            shieldedApps = saved
        }
    }
    
    private func saveActiveSessions() {
        try? storage.save(activeSessions, forKey: AppGroupStorage.Keys.activeSessions)
    }
    
    private func loadActiveSessions() {
        if let saved = try? storage.load([Session].self, forKey: AppGroupStorage.Keys.activeSessions) {
            activeSessions = saved.filter { $0.isActive && !$0.hasExpired }
        }
    }
}


