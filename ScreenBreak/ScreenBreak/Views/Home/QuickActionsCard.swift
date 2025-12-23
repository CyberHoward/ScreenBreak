//
//  QuickActionsCard.swift
//  ScreenBreak
//
//  Quick action buttons for the home dashboard
//

import SwiftUI

struct QuickActionsCard: View {
    @Binding var showingRequestAccess: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                ActionButton(
                    icon: "hand.raised.app.fill",
                    title: "Request\nAccess",
                    color: .blue
                ) {
                    showingRequestAccess = true
                }
                
                ActionButton(
                    icon: "chart.bar.fill",
                    title: "View\nInsights",
                    color: .purple
                ) {
                    // Navigate to insights
                }
            }
            
            HStack(spacing: 12) {
                ActionButton(
                    icon: "gear",
                    title: "Settings",
                    color: .gray
                ) {
                    // Navigate to settings
                }
                
                ActionButton(
                    icon: "apps.iphone",
                    title: "Manage\nApps",
                    color: .orange
                ) {
                    // Navigate to manage apps
                }
            }
        }
        .padding()
        .background(Color("onboardingCard").opacity(0.5))
        .cornerRadius(16)
        .shadow(color: Color("Shadow").opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(color)
                    .clipShape(Circle())
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.5))
            .cornerRadius(12)
        }
    }
}

struct ActiveSessionsCard: View {
    let sessions: [Session]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Active Sessions")
                .font(.headline)
                .foregroundColor(.secondary)
            
            ForEach(sessions) { session in
                MiniSessionTimerView(session: session)
            }
        }
        .padding()
        .background(Color("onboardingCard").opacity(0.5))
        .cornerRadius(16)
        .shadow(color: Color("Shadow").opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

