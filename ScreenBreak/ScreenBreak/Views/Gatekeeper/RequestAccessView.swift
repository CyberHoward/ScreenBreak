//
//  RequestAccessView.swift
//  ScreenBreak
//
//  Main view for requesting access to blocked apps (Opal-style)
//

import SwiftUI
import FamilyControls

struct RequestAccessView: View {
    @StateObject private var viewModel = GatekeeperViewModel()
    @ObservedObject private var shieldService = ShieldManagementService.shared
    @State private var showingIntentInput = false
    @State private var selectedToken: ApplicationToken?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                if shieldService.shieldedApps.isEmpty {
                    emptyState
                } else {
                    blockedAppsList
                }
            }
            .navigationTitle("Request Access")
            .sheet(isPresented: $showingIntentInput) {
                if let token = selectedToken {
                    IntentInputView(
                        viewModel: viewModel,
                        appToken: token,
                        isPresented: $showingIntentInput
                    )
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.shield")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("No Blocked Apps")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("All apps are currently accessible")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
    }
    
    private var blockedAppsList: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Active sessions
                if !shieldService.activeSessions.isEmpty {
                    activeSessionsSection
                }
                
                // Blocked apps
                blockedAppsSection
            }
            .padding()
        }
    }
    
    private var activeSessionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Active Sessions")
                .font(.headline)
                .foregroundColor(.secondary)
            
            ForEach(shieldService.activeSessions) { session in
                if let appToken = session.getApplicationToken() {
                    ActiveSessionCard(session: session, appToken: appToken)
                }
            }
        }
    }
    
    private var blockedAppsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Blocked Apps")
                .font(.headline)
                .foregroundColor(.secondary)
            
            let selection = shieldService.shieldedApps.toFamilyActivitySelection()
            
            ForEach(Array(selection.applicationTokens), id: \.self) { token in
                BlockedAppCard(token: token) {
                    requestAccess(for: token)
                }
            }
        }
    }
    
    private func requestAccess(for token: ApplicationToken) {
        selectedToken = token
        Task {
            await viewModel.requestAccess(for: token, appName: "this app")
            showingIntentInput = true
        }
    }
}

// MARK: - Blocked App Card

struct BlockedAppCard: View {
    let token: ApplicationToken
    let onRequestAccess: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // App icon and name
            Label(token)
                .labelStyle(.iconOnly)
                .frame(width: 40, height: 40)
            
            Label(token)
                .labelStyle(.titleOnly)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            Button(action: onRequestAccess) {
                Text("Request Access")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color("onboardingCard").opacity(0.5))
        .cornerRadius(12)
        .shadow(color: Color("Shadow").opacity(0.1), radius: 3, x: 0, y: 2)
    }
}

// MARK: - Active Session Card

struct ActiveSessionCard: View {
    let session: Session
    let appToken: ApplicationToken
    @ObservedObject private var sessionMonitor = SessionMonitorService.shared
    
    var body: some View {
        HStack(spacing: 12) {
            Label(appToken)
                .labelStyle(.iconOnly)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Label(appToken)
                    .labelStyle(.titleOnly)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text("\(session.remainingMinutes) min remaining")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.title2)
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.green.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    RequestAccessView()
}
