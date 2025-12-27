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
                .foregroundColor(AppColors.textMuted)
            
            HStack(spacing: 12) {
                ActionButton(
                    icon: "hand.raised.app.fill",
                    title: "Request\nAccess",
                    color: AppColors.secondary
                ) {
                    showingRequestAccess = true
                }
                
                ActionButton(
                    icon: "chart.bar.fill",
                    title: "View\nInsights",
                    color: AppColors.info
                ) {
                    // Navigate to insights
                }
            }
            
            HStack(spacing: 12) {
                ActionButton(
                    icon: "gear",
                    title: "Settings",
                    color: AppColors.textMuted
                ) {
                    // Navigate to settings
                }
                
                ActionButton(
                    icon: "apps.iphone",
                    title: "Manage\nApps",
                    color: AppColors.warning
                ) {
                    // Navigate to manage apps
                }
            }
        }
        .padding()
        .background(AppColors.bgLight.opacity(0.8))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.borderMuted, lineWidth: 1)
        )
        .cornerRadius(16)
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
                    .foregroundColor(AppColors.text)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(AppColors.highlight.opacity(0.3))
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
                .foregroundColor(AppColors.textMuted)
            
            ForEach(sessions) { session in
                MiniSessionTimerView(session: session)
            }
        }
        .padding()
        .background(AppColors.bgLight.opacity(0.8))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.borderMuted, lineWidth: 1)
        )
        .cornerRadius(16)
    }
}



