//
//  Attempt.swift
//  ScreenBreak
//
//  Represents an attempt to access a shielded app (approved or denied)
//

import Foundation

struct Attempt: Codable, Identifiable {
    var id: UUID
    
    /// When the attempt was made
    var timestamp: Date
    
    /// Application token data (opaque)
    var appTokenData: Data
    
    /// User's stated intent
    var intent: String
    
    /// AI's decision
    var decision: Decision
    
    /// AI's reasoning/message
    var reason: String
    
    /// Time granted (if allowed)
    var minutesGranted: Int?
    
    enum Decision: String, Codable {
        case allowed = "allowed"
        case denied = "denied"
        case gaveUp = "gave_up"
    }
    
    // MARK: - Computed Properties
    
    var wasSuccessful: Bool {
        decision == .allowed
    }
    
    var dayKey: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: timestamp)
    }
    
    // MARK: - Initialization
    
    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        appTokenData: Data,
        intent: String,
        decision: Decision,
        reason: String,
        minutesGranted: Int? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.appTokenData = appTokenData
        self.intent = intent
        self.decision = decision
        self.reason = reason
        self.minutesGranted = minutesGranted
    }
}

// MARK: - Statistics Helpers

extension Array where Element == Attempt {
    /// Get attempts for today
    var today: [Attempt] {
        let calendar = Calendar.current
        return filter { calendar.isDateInToday($0.timestamp) }
    }
    
    /// Count attempts for today
    var todayCount: Int {
        today.count
    }
    
    /// Count successful attempts for today
    var todaySuccessCount: Int {
        today.filter { $0.wasSuccessful }.count
    }
    
    /// Count denied attempts for today
    var todayDeniedCount: Int {
        today.filter { $0.decision == .denied }.count
    }
    
    /// Total minutes granted today
    var todayMinutesGranted: Int {
        today.compactMap { $0.minutesGranted }.reduce(0, +)
    }
}


