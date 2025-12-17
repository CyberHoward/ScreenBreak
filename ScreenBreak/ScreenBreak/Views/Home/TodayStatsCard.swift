//
//  TodayStatsCard.swift
//  ScreenBreak
//
//  Card showing today's usage statistics
//

import SwiftUI

struct TodayStatsCard: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Activity")
                .font(.headline)
                .foregroundColor(.secondary)
            
            // Usage ring
            HStack(spacing: 24) {
                // Circular progress
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                        .frame(width: 100, height: 100)
                    
                    Circle()
                        .trim(from: 0, to: viewModel.usagePercentage)
                        .stroke(
                            usageColor,
                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                        )
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 2) {
                        Text("\(viewModel.todayMinutesUsed)")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("of \(viewModel.dailyLimit)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Stats breakdown
                VStack(alignment: .leading, spacing: 12) {
                    StatRow(
                        icon: "checkmark.circle.fill",
                        label: "Approved",
                        value: "\(viewModel.todaySuccessfulAttempts)",
                        color: .green
                    )
                    
                    StatRow(
                        icon: "hand.raised.fill",
                        label: "Denied",
                        value: "\(viewModel.todayDeniedAttempts)",
                        color: .orange
                    )
                    
                    StatRow(
                        icon: "clock.fill",
                        label: "Remaining",
                        value: "\(viewModel.minutesRemaining) min",
                        color: .blue
                    )
                }
            }
            
            // Attempts count
            Divider()
            
            HStack {
                Image(systemName: "arrow.up.circle.fill")
                    .foregroundColor(.blue)
                
                Text("You've requested access \(viewModel.todayAttemptsCount) time\(viewModel.todayAttemptsCount == 1 ? "" : "s") today")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
        }
        .padding()
        .background(Color("onboardingCard").opacity(0.5))
        .cornerRadius(16)
        .shadow(color: Color("Shadow").opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var usageColor: Color {
        if viewModel.usagePercentage >= 0.9 {
            return .red
        } else if viewModel.usagePercentage >= 0.7 {
            return .orange
        } else {
            return .green
        }
    }
}

struct StatRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}
