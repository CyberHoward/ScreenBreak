//
//  IntentInputView.swift
//  ScreenBreak
//
//  View for user to input their intent for accessing an app
//
//  MINIMAL BUILD VERSION - FamilyControls features commented out

import SwiftUI
// import FamilyControls  // Commented out for minimal build

struct IntentInputView: View {
    // MINIMAL BUILD - Properties commented out
    // @Bindable var viewModel: GatekeeperViewModel
    // let appToken: ApplicationToken
    // @Binding var isPresented: Bool
    
    // @State private var showingResult = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                // MINIMAL BUILD - Show placeholder
                Text("Feature disabled in minimal build")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Request Access")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    /* COMMENTED OUT FOR MINIMAL BUILD - Re-enable when FamilyControls is properly configured
    private var intentInputForm: some View {
        ScrollView {
            VStack(spacing: 24) {
                // App display
                VStack(spacing: 12) {
                    Label(appToken)
                        .labelStyle(.iconOnly)
                        .frame(width: 60, height: 60)
                    
                    Label(appToken)
                        .labelStyle(.titleOnly)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .padding(.top, 20)
                
                // Question
                VStack(spacing: 8) {
                    Text("What do you want to do?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Be honest - it helps the AI make better decisions")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                // Text input
                VStack(alignment: .leading, spacing: 8) {
                    TextField("Type your reason here...", text: $viewModel.userIntent, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...6)
                        .disabled(viewModel.isLoading)
                    
                    Text("\(viewModel.userIntent.count) characters")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Quick options
                VStack(alignment: .leading, spacing: 12) {
                    Text("Or choose a quick option:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(viewModel.quickIntents, id: \.self) { intent in
                            Button(action: {
                                Task {
                                    await viewModel.useQuickIntent(intent)
                                    showingResult = true
                                }
                            }) {
                                Text(intent)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("onboardingCard").opacity(0.5))
                                    .cornerRadius(8)
                            }
                            .disabled(viewModel.isLoading)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Submit button
                Button(action: {
                    Task {
                        await viewModel.submitIntent(viewModel.userIntent)
                        showingResult = true
                    }
                }) {
                    Group {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Submit")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.userIntent.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(viewModel.userIntent.isEmpty || viewModel.isLoading)
                .padding(.horizontal)
                
                // Error message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
    
    @ViewBuilder
    private func resultView(for decision: GatekeeperAIService.GatekeeperDecision) -> some View {
        switch decision {
        case .allow(let minutes, let message):
            AccessGrantedView(
                minutes: minutes,
                message: message,
                isPresented: $isPresented
            )
        case .deny(let reason, let alternatives):
            AccessDeniedView(
                reason: reason,
                alternatives: alternatives,
                isPresented: $isPresented
            )
        case .followUp(let question):
            followUpView(question: question)
        }
    }
    
    private func followUpView(question: String) -> some View {
        VStack(spacing: 24) {
            Image(systemName: "questionmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("One more thing...")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(question)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            TextField("Your answer...", text: $viewModel.userIntent, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(2...4)
                .padding(.horizontal)
            
            Button(action: {
                Task {
                    await viewModel.submitIntent(viewModel.userIntent)
                }
            }) {
                Text("Answer")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(viewModel.userIntent.isEmpty || viewModel.isLoading)
            .padding(.horizontal)
        }
        .padding()
    }
    */
}

