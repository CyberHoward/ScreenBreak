//
//  PactConfirmationView.swift
//  ScreenBreak
//
//  Final confirmation and authorization screen
//

import SwiftUI
import RiveRuntime

struct PactConfirmationView: View {
    @Binding var viewModel: OnboardingViewModel
    @State private var showingShieldExplanation = false
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                loadingView
            } else if !viewModel.isAuthorized {
                authorizationView
            } else {
                confirmationView
            }
        }
        .alert("How the Shield Works", isPresented: $showingShieldExplanation) {
            Button("Got it!", role: .cancel) {}
        } message: {
            Text("When you try to open a blocked app, you'll see a shield screen. Simply open ScreenBreak, tap 'Request Access', and tell the AI what you want to do. The AI will approve or deny based on your pact rules.")
        }
    }
    
    private var authorizationView: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            VStack(spacing: 12) {
                Text("Authorization Required")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("ScreenBreak needs Screen Time permissions to protect your apps")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 16) {
                InfoRow(icon: "checkmark.shield", text: "Your data stays on your device")
                InfoRow(icon: "hand.raised", text: "You can revoke access anytime")
                InfoRow(icon: "lock", text: "Requires Face ID or passcode")
            }
            .padding()
            .background(Color("onboardingCard").opacity(0.3))
            .cornerRadius(12)
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                Task {
                    await viewModel.requestAuthorization()
                }
            }) {
                Text("Grant Permission")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            
            Button("Go Back") {
                viewModel.previousStep()
            }
            .foregroundColor(.secondary)
            .padding(.bottom, 32)
        }
    }
    
    private var confirmationView: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Success animation
            RiveViewModel(fileName: "confetti").view()
                .frame(height: 200)
            
            VStack(spacing: 12) {
                Text("Pact Started!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Day 1 of \(viewModel.pactDuration)")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            // Summary
            VStack(alignment: .leading, spacing: 16) {
                SummaryRow(
                    icon: "target",
                    title: "Your Goal",
                    value: viewModel.motivation
                )
                
                SummaryRow(
                    icon: "calendar",
                    title: "Duration",
                    value: "\(viewModel.pactDuration) days"
                )
                
                SummaryRow(
                    icon: "apps.iphone",
                    title: "Shielded Apps",
                    value: "\(viewModel.selectedApps.applicationTokens.count) apps"
                )
                
                SummaryRow(
                    icon: "clock",
                    title: "Daily Limit",
                    value: "\(viewModel.rules.dailyLimitMinutes) minutes"
                )
            }
            .padding()
            .background(Color("onboardingCard").opacity(0.3))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // Important note
            Button(action: {
                showingShieldExplanation = true
            }) {
                HStack {
                    Image(systemName: "info.circle.fill")
                    Text("How to request access")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .font(.subheadline)
                .padding()
                .background(Color.blue.opacity(0.1))
                .foregroundColor(.blue)
                .cornerRadius(8)
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                Task {
                    try? await viewModel.createPact()
                }
            }) {
                Text("Start My Pact")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Creating your pact...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(text)
                .font(.subheadline)
            
            Spacer()
        }
    }
}

struct SummaryRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
    }
}


