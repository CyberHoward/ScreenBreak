//
//  Pact.swift
//  ScreenBreak
//
//  Represents a time-bound commitment (e.g., 14-day pact)
//

import Foundation

struct Pact: Codable, Identifiable {
    var id: UUID
    
    /// When the pact started
    var startDate: Date
    
    /// Duration in days (e.g., 7, 14, 30)
    var durationDays: Int
    
    /// User's motivation for this pact
    var motivation: String
    
    /// Rules for this pact
    var rules: PactRules
    
    /// Current streak (consecutive days without breaking rules)
    var streak: Int
    
    /// Whether the pact is still active
    var isActive: Bool
    
    // MARK: - Computed Properties
    
    var endDate: Date {
        Calendar.current.date(byAdding: .day, value: durationDays, to: startDate) ?? startDate
    }
    
    var currentDay: Int {
        let daysPassed = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
        return min(daysPassed + 1, durationDays)
    }
    
    var isComplete: Bool {
        Date() >= endDate
    }
    
    var daysRemaining: Int {
        max(0, durationDays - currentDay + 1)
    }
    
    var progressPercentage: Double {
        Double(currentDay) / Double(durationDays)
    }
    
    // MARK: - Initialization
    
    init(
        id: UUID = UUID(),
        startDate: Date = Date(),
        durationDays: Int,
        motivation: String,
        rules: PactRules,
        streak: Int = 0,
        isActive: Bool = true
    ) {
        self.id = id
        self.startDate = startDate
        self.durationDays = durationDays
        self.motivation = motivation
        self.rules = rules
        self.streak = streak
        self.isActive = isActive
    }
    
    // MARK: - Factory Methods
    
    static func create(
        duration: Int,
        motivation: String,
        rules: PactRules
    ) -> Pact {
        return Pact(
            durationDays: duration,
            motivation: motivation,
            rules: rules
        )
    }
}



