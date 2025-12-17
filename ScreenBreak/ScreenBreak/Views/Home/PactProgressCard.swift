//
//  PactProgressCard.swift
//  ScreenBreak
//
//  Card showing pact progress and streak
//

import SwiftUI

struct PactProgressCard: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Pact")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Day \(viewModel.currentDay) of \(viewModel.totalDays)")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                // Streak badge
                VStack(spacing: 4) {
                    Text("\(viewModel.streak)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    Text("day streak")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
            }
            
            // Progress bar
            VStack(alignment: .leading, spacing: 8) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 12)
                        
                        // Progress
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [Color.green, Color.blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * viewModel.pactProgress, height: 12)
                    }
                }
                .frame(height: 12)
                
                Text("\(Int(viewModel.pactProgress * 100))% complete")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Motivation reminder
            if !viewModel.motivation.isEmpty {
                HStack {
                    Image(systemName: "quote.opening")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Text(viewModel.motivation)
                        .font(.subheadline)
                        .italic()
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding()
                .background(Color.blue.opacity(0.05))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color("onboardingCard").opacity(0.5))
        .cornerRadius(16)
        .shadow(color: Color("Shadow").opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
