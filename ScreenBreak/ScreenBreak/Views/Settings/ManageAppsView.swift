//
//  ManageAppsView.swift
//  ScreenBreak
//
//  View for managing shielded apps
//
//  MINIMAL BUILD VERSION - FamilyControls features commented out

import SwiftUI
// import FamilyControls  // Commented out for minimal build

struct ManageAppsView: View {
    // MINIMAL BUILD - Properties commented out
    // @Bindable var viewModel: SettingsViewModel
    // @State private var showingPicker = false
    // @State private var selection: FamilyActivitySelection
    @Environment(\.dismiss) private var dismiss
    
    /* COMMENTED OUT FOR MINIMAL BUILD
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selection = State(initialValue: viewModel.shieldedApps.toFamilyActivitySelection())
    }
    */
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                // MINIMAL BUILD - Show placeholder
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                    
                    Text("Feature Disabled")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Manage Apps requires FamilyControls\nRe-enable in the full build")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                /* COMMENTED OUT FOR MINIMAL BUILD
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "apps.iphone")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                        
                        Text("Manage Shielded Apps")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("These apps require AI approval")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)
                    
                    // Current apps
                    if !selection.applicationTokens.isEmpty || !selection.categoryTokens.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Selected Apps (\(selection.applicationTokens.count))")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                                
                                ForEach(Array(selection.applicationTokens), id: \.self) { token in
                                    HStack {
                                        Label(token)
                                            .labelStyle(.iconOnly)
                                            .frame(width: 40, height: 40)
                                        
                                        Label(token)
                                            .labelStyle(.titleOnly)
                                            .font(.body)
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color("onboardingCard").opacity(0.5))
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                                }
                            }
                        }
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "tray")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            
                            Text("No apps selected")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxHeight: .infinity)
                    }
                    
                    // Actions
                    VStack(spacing: 12) {
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
                        .familyActivityPicker(isPresented: $showingPicker, selection: $selection)
                        
                        Button(action: {
                            viewModel.updateShieldedApps(selection)
                            dismiss()
                        }) {
                            Text("Save Changes")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .disabled(selection.applicationTokens.isEmpty && selection.categoryTokens.isEmpty)
                    }
                    .padding()
                }
                */
            }
            .navigationTitle("Manage Apps")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

