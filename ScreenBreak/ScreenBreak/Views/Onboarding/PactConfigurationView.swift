//
//  PactConfigurationView.swift
//  ScreenBreak
//
//  Screen for configuring pact duration and rules
//

import SwiftUI

struct PactConfigurationView: View {
    var viewModel: OnboardingViewModel
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "calendar")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text("Choose Your Pact")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Pick a commitment level that challenges you")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                    
                    // Preset options
                    VStack(spacing: 16) {
                        PresetCard(
                            preset: .weekIntro,
                            isSelected: viewModel.pactDuration == 7,
                            action: { viewModel.selectPreset(.weekIntro) }
                        )
                        
                        PresetCard(
                            preset: .twoWeekStandard,
                            isSelected: viewModel.pactDuration == 14,
                            action: { viewModel.selectPreset(.twoWeekStandard) }
                        )
                        
                        PresetCard(
                            preset: .monthChallenge,
                            isSelected: viewModel.pactDuration == 30,
                            action: { viewModel.selectPreset(.monthChallenge) }
                        )
                    }
                    .padding(.horizontal)
                    
                    // Rules summary
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Rules:")
                            .font(.headline)
                        
                        RuleRow(icon: "clock", title: "Daily Limit", value: "\(viewModel.rules.dailyLimitMinutes) minutes")
                        RuleRow(icon: "timer", title: "Per Session", value: "\(viewModel.rules.sessionLimitMinutes) minutes max")
                        RuleRow(icon: "shield", title: "Strictness", value: viewModel.rules.strictness.rawValue.capitalized)
                        
                        if let quietHours = viewModel.rules.quietHours {
                            RuleRow(icon: "moon.stars", title: "Quiet Hours", value: quietHours.description)
                        }
                    }
                    .padding()
                    .background(Color("onboardingCard").opacity(0.3))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            
            // Navigation buttons
            VStack {
                Spacer()
                
                HStack(spacing: 16) {
                    Button(action: {
                        viewModel.previousStep()
                    }) {
                        Text("Back")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        viewModel.nextStep()
                    }) {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(Color("backgroundColor"))
            }
        }
    }
}

struct PresetCard: View {
    let preset: OnboardingViewModel.PactPreset
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(preset.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(preset.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            .padding()
            .background(
                isSelected
                    ? Color.blue.opacity(0.1)
                    : Color("onboardingCard").opacity(0.5)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
    }
}

struct RuleRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
    }
}


