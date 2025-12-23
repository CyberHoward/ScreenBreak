//
//  PactRules.swift
//  ScreenBreak
//
//  Defines the rules for a pact (daily limits, session limits, strictness)
//

import Foundation

struct PactRules: Codable, Equatable {
    /// Daily time limit in minutes (e.g., 30 minutes per day)
    var dailyLimitMinutes: Int
    
    /// Per-session time limit in minutes (e.g., 5, 10, 15 minutes per session)
    var sessionLimitMinutes: Int
    
    /// Strictness level affects AI decision-making
    var strictness: StrictnessLevel
    
    /// Optional quiet hours (no access during these times)
    var quietHours: QuietHours?
    
    enum StrictnessLevel: String, Codable {
        case gentle = "gentle"
        case balanced = "balanced"
        case strict = "strict"
        
        var description: String {
            switch self {
            case .gentle:
                return "Gentle - More lenient with access requests"
            case .balanced:
                return "Balanced - Standard enforcement"
            case .strict:
                return "Strict - Limited access, strong accountability"
            }
        }
    }
    
    struct QuietHours: Codable, Equatable {
        /// Start hour (0-23)
        var startHour: Int
        
        /// End hour (0-23)
        var endHour: Int
        
        var description: String {
            return "No access from \(startHour):00 to \(endHour):00"
        }
    }
    
    // MARK: - Defaults
    
    static let defaultRules = PactRules(
        dailyLimitMinutes: 30,
        sessionLimitMinutes: 10,
        strictness: .balanced,
        quietHours: nil
    )
    
    // MARK: - Validation
    
    var isValid: Bool {
        dailyLimitMinutes > 0 &&
        sessionLimitMinutes > 0 &&
        sessionLimitMinutes <= dailyLimitMinutes &&
        (quietHours?.startHour ?? 0) >= 0 &&
        (quietHours?.startHour ?? 0) <= 23 &&
        (quietHours?.endHour ?? 0) >= 0 &&
        (quietHours?.endHour ?? 0) <= 23
    }
}



