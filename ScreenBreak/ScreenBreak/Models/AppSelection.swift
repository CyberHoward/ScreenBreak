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
    /// Store application tokens as Data
    var applicationTokensData: [Data]
    
    /// Store category tokens as Data
    var categoryTokensData: [Data]
    
    // MARK: - Initialization
    
    init(applicationTokensData: [Data] = [], categoryTokensData: [Data] = []) {
        self.applicationTokensData = applicationTokensData
        self.categoryTokensData = categoryTokensData
    }
    
    /// Initialize from FamilyActivitySelection
    init(from selection: FamilyActivitySelection) {
        self.applicationTokensData = selection.applicationTokens.compactMap { token in
            try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true)
        }
        
        self.categoryTokensData = selection.categoryTokens.compactMap { token in
            try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true)
        }
    }
    
    // MARK: - Conversion
    
    /// Convert to FamilyActivitySelection
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
    
    // MARK: - Properties
    
    var isEmpty: Bool {
        applicationTokensData.isEmpty && categoryTokensData.isEmpty
    }
    
    var count: Int {
        applicationTokensData.count + categoryTokensData.count
    }
}




