//
//  WelcomeView.swift
//  ScreenBreak
//
//  Welcome screen explaining the app concept
//

import SwiftUI
import RiveRuntime

struct WelcomeView: View {
    @Binding var viewModel: OnboardingViewModel
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            // Background animation
            RiveViewModel(fileName: "shapes").view()
                .ignoresSafeArea()
                .blur(radius: 30)
                .background(
                    Image("Spline")
                        .blur(radius: 60)
                        .offset(x: 200, y: 100)
                )
            
            VStack(spacing: 32) {
                Spacer()
                
                // Logo and title
                VStack(spacing: 16) {
                    Image("appLogo")
                        .resizable()
                        .frame(width: 100, height: 100)
                    
                    Text("ScreenBreak")
                        .font(.system(size: 36, weight: .bold))
                    
                    Text("Reclaim your attention")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Problem statement
                VStack(spacing: 24) {
                    FeatureCard(
                        icon: "brain.head.profile",
                        title: "The Problem",
                        description: "Social media is designed to hijack your attention. Compulsive scrolling wastes hours every day."
                    )
                    
                    FeatureCard(
                        icon: "sparkles",
                        title: "The Solution",
                        description: "AI-powered gatekeeper. State your intent before accessing apps. Only get in when it aligns with your goals."
                    )
                    
                    FeatureCard(
                        icon: "flag.checkered",
                        title: "The Commitment",
                        description: "Time-bound pact. Choose 7, 14, or 30 days. Break the compulsion and reset your relationship with social media."
                    )
                }
                .padding(.horizontal)
                
                Spacer()
                
                // CTA
                Button(action: {
                    viewModel.nextStep()
                }) {
                    Text("Start Your Pact")
                        .font(.headline)
                        .fontWeight(.semibold)
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
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color("onboardingCard").opacity(0.5))
        .cornerRadius(12)
    }
}


