//
//  AppGroupStorage.swift
//  ScreenBreak
//
//  Service for accessing shared data between main app and extensions via App Group
//

import Foundation

final class AppGroupStorage {
    static let shared = AppGroupStorage()
    
    // App Group identifier shared across main app and extensions
    private let appGroupIdentifier = "group.com.ohmroger.screenbreak"
    
    // Shared UserDefaults
    private(set) lazy var userDefaults: UserDefaults = {
        guard let defaults = UserDefaults(suiteName: appGroupIdentifier) else {
            fatalError("Failed to initialize UserDefaults with App Group identifier: \(appGroupIdentifier)")
        }
        return defaults
    }()
    
    // Shared container URL for file storage
    var containerURL: URL {
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier) else {
            fatalError("Failed to get container URL for App Group identifier: \(appGroupIdentifier)")
        }
        return url
    }
    
    private init() {}
    
    // MARK: - Convenience Methods
    
    /// Save any Codable object to shared storage
    func save<T: Codable>(_ object: T, forKey key: String) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        userDefaults.set(data, forKey: key)
    }
    
    /// Load a Codable object from shared storage
    func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
    
    /// Remove object for key
    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    /// Check if key exists
    func exists(forKey key: String) -> Bool {
        return userDefaults.object(forKey: key) != nil
    }
    
    // MARK: - Common Keys
    
    struct Keys {
        static let activePact = "activePact"
        static let shieldedApps = "shieldedApps"
        static let activeSessions = "activeSessions"
        static let todayAttempts = "todayAttempts"
        static let lastUpdateDate = "lastUpdateDate"
    }
}






