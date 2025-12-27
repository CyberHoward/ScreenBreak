//
//  AppSelection.swift
//  ScreenBreak
//
//  Wrapper for FamilyActivitySelection with Codable support
//

import Foundation
import ManagedSettings
import FamilyControls

struct AppSelection: Codable {
    /// Store application tokens as Data (encoded using PropertyListEncoder for Codable types)
    var applicationTokensData: [Data]
    
    /// Store category tokens as Data (encoded using PropertyListEncoder for Codable types)
    var categoryTokensData: [Data]
    
    /// Store app names mapped by their token data (base64 encoded for dictionary key)
    /// Key: Base64 string of token data, Value: App display name
    var appNamesByTokenData: [String: String]
    
    // MARK: - Initialization
    
    init(applicationTokensData: [Data] = [], categoryTokensData: [Data] = [], appNamesByTokenData: [String: String] = [:]) {
        self.applicationTokensData = applicationTokensData
        self.categoryTokensData = categoryTokensData
        self.appNamesByTokenData = appNamesByTokenData
    }
    
    /// Initialize from FamilyActivitySelection (without names - legacy support)
    init(from selection: FamilyActivitySelection) {
        let encoder = PropertyListEncoder()
        
        self.applicationTokensData = selection.applicationTokens.compactMap { token in
            try? encoder.encode(token)
        }
        
        self.categoryTokensData = selection.categoryTokens.compactMap { token in
            try? encoder.encode(token)
        }
        
        // Build app names from Application objects if available
        var names: [String: String] = [:]
        for application in selection.applications {
            if let token = application.token,
               let tokenData = try? encoder.encode(token),
               let displayName = application.localizedDisplayName {
                let key = tokenData.base64EncodedString()
                names[key] = displayName
            }
        }
        self.appNamesByTokenData = names
    }
    
    // MARK: - Conversion
    
    /// Convert to FamilyActivitySelection
    func toFamilyActivitySelection() -> FamilyActivitySelection {
        var selection = FamilyActivitySelection()
        let decoder = PropertyListDecoder()
        
        selection.applicationTokens = Set(applicationTokensData.compactMap { data in
            try? decoder.decode(ApplicationToken.self, from: data)
        })
        
        selection.categoryTokens = Set(categoryTokensData.compactMap { data in
            try? decoder.decode(ActivityCategoryToken.self, from: data)
        })
        
        return selection
    }
    
    // MARK: - Properties
    
    var isEmpty: Bool {
        applicationTokensData.isEmpty && categoryTokensData.isEmpty
    }
    
    var count: Int {
        applicationTokensData.count + categoryTokensData.count
    }
    
    /// Get app name for a given ApplicationToken
    func getAppName(for token: ApplicationToken) -> String? {
        let encoder = PropertyListEncoder()
        guard let tokenData = try? encoder.encode(token) else { return nil }
        let key = tokenData.base64EncodedString()
        return appNamesByTokenData[key]
    }
    
    /// Get all stored app names
    var allAppNames: [String] {
        Array(appNamesByTokenData.values)
    }
    
    /// Get app names for a set of tokens
    func getAppNames(for tokens: Set<ApplicationToken>) -> [String] {
        tokens.compactMap { getAppName(for: $0) }
    }
}




