//
//  OnboardingContainerView.swift
//  ScreenBreak
//
//  Container for onboarding flow navigation
//

import SwiftUI

struct OnboardingContainerView: View {
    @State private var viewModel = OnboardingViewModel()
    @Binding var isOnboardingComplete: Bool
    
    var body: some View {
        ZStack {
            switch viewModel.currentStep {
            case .welcome:
                WelcomeView(viewModel: viewModel)
            case .motivation:
                MotivationInputView(viewModel: viewModel)
            case .pactConfiguration:
                PactConfigurationView(viewModel: viewModel)
            case .shieldedApps:
                ShieldedAppsSelectionView(viewModel: viewModel)
            case .confirmation:
                PactConfirmationView(viewModel: viewModel)
            case .completed:
                Color.clear
                    .onAppear {
                        isOnboardingComplete = true
                    }
            }
        }
        .transition(.slide)
        .animation(.easeInOut, value: viewModel.currentStep)
    }
}


