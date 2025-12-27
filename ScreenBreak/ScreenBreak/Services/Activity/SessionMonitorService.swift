//
//  SessionMonitorService.swift
//  ScreenBreak
//
//  Service for monitoring active sessions and triggering cleanup
//

import Foundation
import Combine

final class SessionMonitorService: ObservableObject {
    static let shared = SessionMonitorService()
    
    private let shieldService = ShieldManagementService.shared
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var activeSessions: [Session] = []
    
    private init() {
        // Observe shield service sessions
        shieldService.$activeSessions
            .assign(to: &$activeSessions)
        
        startMonitoring()
    }
    
    // MARK: - Monitoring
    
    func startMonitoring() {
        // Check every 30 seconds for expired sessions
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.checkExpiredSessions()
        }
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkExpiredSessions() {
        shieldService.checkExpiredSessions()
    }
    
    // MARK: - Session Queries
    
    func getRemainingTime(for sessionId: UUID) -> Int? {
        guard let session = activeSessions.first(where: { $0.id == sessionId }) else {
            return nil
        }
        return session.remainingMinutes
    }
    
    func hasActiveSession(for appToken: Data) -> Bool {
        return activeSessions.contains { session in
            session.isActive && 
            !session.hasExpired && 
            session.appTokenData == appToken
        }
    }
}




