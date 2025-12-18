//
//  MotivationInputView.swift
//  ScreenBreak
//
//  Screen for user to input their motivation
//

import SwiftUI

struct MotivationInputView: View {
    @Binding var viewModel: OnboardingViewModel
    
    let commonMotivations = [
        "Better sleep",
        "More focus at work",
        "Be more present with family",
        "Reduce anxiety",
        "Read more books",
        "Start a side project"
    ]
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "target")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text("Why are you doing this?")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("This will be your north star when temptation strikes")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 40)
                    
                    // Text input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your motivation:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("I want to...", text: $viewModel.motivation, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(2...5)
                        
                        Text("\(viewModel.motivation.count) characters")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    // Quick options
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Or choose a common one:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(commonMotivations, id: \.self) { motivation in
                                Button(action: {
                                    viewModel.motivation = motivation
                                }) {
                                    Text(motivation)
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            viewModel.motivation == motivation
                                                ? Color.blue.opacity(0.2)
                                                : Color("onboardingCard").opacity(0.5)
                                        )
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
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


