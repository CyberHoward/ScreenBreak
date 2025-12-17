//
//  Session.swift
//  ScreenBreak
//
//  Represents a time-boxed access session for a shielded app
//

import Foundation
import FamilyControls

struct Session: Codable, Identifiable {
    var id: UUID
    
    /// Application token (opaque - cannot be decoded)
    /// Store as Data to make it Codable
    var appTokenData: Data
    
    /// When the session started
    var startTime: Date
    
    /// When the session should end
    var endTime: Date
    
    /// Time allowed in minutes
    var timeAllowedMinutes: Int
    
    /// Actual time used (updated when session ends)
    var timeUsedMinutes: Int?
    
    /// User's stated intent for this session
    var intent: String
    
    /// AI's decision for granting access
    var aiDecision: String
    
    /// Whether session is currently active
    var isActive: Bool
    
    // MARK: - Computed Properties
    
    var remainingMinutes: Int {
        let remaining = Int(endTime.timeIntervalSince(Date()) / 60)
        return max(0, remaining)
    }
    
    var hasExpired: Bool {
        Date() >= endTime
    }
    
    var duration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }
    
    // MARK: - Initialization
    
    init(
        id: UUID = UUID(),
        appTokenData: Data,
        startTime: Date = Date(),
        timeAllowedMinutes: Int,
        intent: String,
        aiDecision: String,
        isActive: Bool = true
    ) {
        self.id = id
        self.appTokenData = appTokenData
        self.startTime = startTime
        self.endTime = startTime.addingTimeInterval(TimeInterval(timeAllowedMinutes * 60))
        self.timeAllowedMinutes = timeAllowedMinutes
        self.timeUsedMinutes = nil
        self.intent = intent
        self.aiDecision = aiDecision
        self.isActive = isActive
    }
    
    // MARK: - Methods
    
    mutating func end(actualMinutes: Int? = nil) {
        isActive = false
        if let actualMinutes = actualMinutes {
            timeUsedMinutes = actualMinutes
        } else {
            // Calculate based on elapsed time
            let elapsed = Date().timeIntervalSince(startTime)
            timeUsedMinutes = Int(elapsed / 60)
        }
    }
}

// MARK: - Helper for ApplicationToken conversion

extension Session {
    /// Initialize with ApplicationToken (convenience)
    init(
        appToken: ApplicationToken,
        timeAllowedMinutes: Int,
        intent: String,
        aiDecision: String
    ) {
        // Convert ApplicationToken to Data for storage
        // We can't decode the token, but we can store it as data
        let data = try! NSKeyedArchiver.archivedData(withRootObject: appToken, requiringSecureCoding: true)
        
        self.init(
            appTokenData: data,
            timeAllowedMinutes: timeAllowedMinutes,
            intent: intent,
            aiDecision: aiDecision
        )
    }
    
    /// Retrieve ApplicationToken from stored data
    func getApplicationToken() -> ApplicationToken? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: ApplicationToken.self, from: appTokenData)
    }
}
