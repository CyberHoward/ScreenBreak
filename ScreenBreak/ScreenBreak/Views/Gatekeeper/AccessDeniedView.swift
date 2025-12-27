//
//  AccessDeniedView.swift
//  ScreenBreak
//
//  View shown when AI denies access to an app
//

import SwiftUI

struct AccessDeniedView: View {
    let reason: String
    let alternatives: [String]
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Denied icon
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.orange)
            }
            
            // Title
            VStack(spacing: 12) {
                Text("Not Right Now")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Let's protect your time")
                    .font(.title3)
                    .foregroundColor(.orange)
            }
            
            // AI message
            Text(reason)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 32)
            
            // Alternatives
            if !alternatives.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Try instead:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    
                    ForEach(alternatives, id: \.self) { alternative in
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.blue)
                            
                            Text(alternative)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color("onboardingCard").opacity(0.3))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 32)
            }
            
            Spacer()
            
            // Action buttons
            VStack(spacing: 12) {
                Button(action: {
                    isPresented = false
                }) {
                    Text("Got It")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                Button(action: {
                    // Could retry with different intent
                    isPresented = false
                }) {
                    Text("Back to Dashboard")
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 20)
        }
        .background(Color("backgroundColor"))
    }
}

#Preview {
    AccessDeniedView(
        reason: "You've already used 28 of your 30 minutes today. You're so close to your goal!",
        alternatives: [
            "Take a 5-minute walk",
            "Write in your journal",
            "Text them instead"
        ],
        isPresented: .constant(true)
    )
}





