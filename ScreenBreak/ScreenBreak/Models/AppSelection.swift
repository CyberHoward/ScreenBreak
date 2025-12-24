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
    
    // MARK: - Initialization
    
    init(applicationTokensData: [Data] = [], categoryTokensData: [Data] = []) {
        self.applicationTokensData = applicationTokensData
        self.categoryTokensData = categoryTokensData
    }
    
    /// Initialize from FamilyActivitySelection
    init(from selection: FamilyActivitySelection) {
        let encoder = PropertyListEncoder()
        
        self.applicationTokensData = selection.applicationTokens.compactMap { token in
            try? encoder.encode(token)
        }
        
        self.categoryTokensData = selection.categoryTokens.compactMap { token in
            try? encoder.encode(token)
        }
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
}




