//
//  ShieldedAppsSelectionView.swift
//  ScreenBreak
//
//  Screen for selecting apps to shield
//

import SwiftUI
import FamilyControls
import ManagedSettings

// Separate view to encapsulate the Label lifecycle and prevent hierarchy warnings
private struct OnboardingAppTokenCell: View {
    let token: ApplicationToken
    
    var body: some View {
        VStack(spacing: 8) {
            Label(token)
                .labelStyle(.iconOnly)
                .frame(width: 50, height: 50)
            
            Label(token)
                .labelStyle(.titleOnly)
                .font(.caption)
                .lineLimit(2)
                .frame(width: 70)
        }
    }
}

struct ShieldedAppsSelectionView: View {
    @Bindable var viewModel: OnboardingViewModel
    @State private var showingPicker = false
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "apps.iphone")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Choose Apps to Shield")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("These apps will require AI approval before accessing")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 40)
                
                // Selected apps display
                if !viewModel.selectedApps.applicationTokens.isEmpty || !viewModel.selectedApps.categoryTokens.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Selected Apps (\(viewModel.selectedApps.applicationTokens.count + viewModel.selectedApps.categoryTokens.count))")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(Array(viewModel.selectedApps.applicationTokens), id: \.self) { token in
                                    OnboardingAppTokenCell(token: token)
                                }
                            }
                            .padding()
                        }
                    }
                    .padding(.horizontal)
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "tray")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        
                        Text("No apps selected yet")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                }
                
                // Select apps button
                Button(action: {
                    showingPicker = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Select Apps")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .familyActivityPicker(isPresented: $showingPicker, selection: $viewModel.selectedApps)
                
                // Authorization note
                VStack(spacing: 8) {
                    Image(systemName: "lock.shield")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("You'll be asked to authorize Screen Time permissions in the next step")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
                
                Spacer()
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
                            .background(viewModel.canProceed ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(!viewModel.canProceed)
                }
                .padding()
                .background(Color("backgroundColor"))
            }
        }
    }
}
