//
//  AuthorizationService.swift
//  ScreenBreak
//
//  Service for managing Screen Time API authorization
//

import Foundation
import FamilyControls

final class AuthorizationService {
    static let shared = AuthorizationService()
    
    private let center = AuthorizationCenter.shared
    
    private init() {}
    
    // MARK: - Authorization
    
    /// Request Screen Time API permissions
    func requestPermissions() async throws {
        try await center.requestAuthorization(for: .individual)
    }
    
    /// Check current authorization status
    func checkAuthorizationStatus() -> AuthorizationCenter.AuthorizationStatus {
        return center.authorizationStatus
    }
    
    /// Check if we have authorization
    var isAuthorized: Bool {
        return center.authorizationStatus == .approved
    }
    
    /// Revoke authorization (user must do this in Settings)
    func revokeAuthorization() {
        // Note: We can't programmatically revoke, user must do it in Settings
        // This method is here for documentation purposes
    }
}
