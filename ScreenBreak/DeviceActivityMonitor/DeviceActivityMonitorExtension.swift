//
//  DeviceActivityMonitorExtension.swift
//  DeviceActivityMonitor
//
//  Monitors device activity and handles session expiration cleanup
//

import Foundation
import DeviceActivity
import FamilyControls
import ManagedSettings

// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    let store = ManagedSettingsStore(named: ManagedSettingsStore.Name("ScreenBreakStore"))
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        // Session interval started - shield is already active
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        // Session time expired - re-apply full shield
        // Load shielded apps from App Group storage
        if let shieldedApps = loadShieldedApps() {
            applyShield(shieldedApps)
        }
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        // Event threshold reached - could be used for warnings
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        // Warning before session ends - could trigger notification
    }
    
    // MARK: - Private Helpers
    
    private func loadShieldedApps() -> AppSelection? {
        let suiteName = "group.com.screenbreak.shared"
        guard let defaults = UserDefaults(suiteName: suiteName),
              let data = defaults.data(forKey: "shieldedApps") else {
            return nil
        }
        
        return try? JSONDecoder().decode(AppSelection.self, from: data)
    }
    
    private func applyShield(_ selection: AppSelection) {
        let familySelection = selection.toFamilyActivitySelection()
        
        store.shield.applications = familySelection.applicationTokens.isEmpty 
            ? nil 
            : familySelection.applicationTokens
        
        store.shield.applicationCategories = familySelection.categoryTokens.isEmpty
            ? nil
            : ShieldSettings.ActivityCategoryPolicy.specific(familySelection.categoryTokens)
    }
}

// MARK: - AppSelection for Extension

/// Minimal AppSelection implementation for extension use
struct AppSelection: Codable {
    var applicationTokensData: [Data]
    var categoryTokensData: [Data]
    
    func toFamilyActivitySelection() -> FamilyActivitySelection {
        var selection = FamilyActivitySelection()
        
        selection.applicationTokens = Set(applicationTokensData.compactMap { data in
            try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? ApplicationToken
        })
        
        selection.categoryTokens = Set(categoryTokensData.compactMap { data in
            try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? ActivityCategoryToken
        })
        
        return selection
    }
}
