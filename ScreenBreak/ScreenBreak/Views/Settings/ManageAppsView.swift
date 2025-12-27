//
//  ManageAppsView.swift
//  ScreenBreak
//
//  View for managing shielded apps
//

import SwiftUI
import FamilyControls
import ManagedSettings

// Separate view to encapsulate the Label lifecycle and prevent hierarchy warnings
private struct AppTokenRow: View {
    let token: ApplicationToken
    
    var body: some View {
        HStack {
            Label(token)
                .labelStyle(.iconOnly)
                .frame(width: 40, height: 40)
            
            Label(token)
                .labelStyle(.titleOnly)
                .font(.body)
                .foregroundColor(AppColors.text)
            
            Spacer()
        }
        .padding()
        .background(AppColors.bgLight.opacity(0.8))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.borderMuted, lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

struct ManageAppsView: View {
    @Bindable var viewModel: SettingsViewModel
    @State private var showingPicker = false
    @State private var selection: FamilyActivitySelection
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selection = State(initialValue: viewModel.shieldedApps.toFamilyActivitySelection())
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.bg
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "apps.iphone")
                            .font(.system(size: 50))
                            .foregroundColor(AppColors.secondary)
                        
                        Text("Manage Shielded Apps")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.text)
                        
                        Text("These apps require AI approval")
                            .font(.subheadline)
                            .foregroundColor(AppColors.textMuted)
                    }
                    .padding(.top)
                    
                    // Current apps
                    if !selection.applicationTokens.isEmpty || !selection.categoryTokens.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Selected Apps (\(selection.applicationTokens.count))")
                                    .font(.headline)
                                    .foregroundColor(AppColors.textMuted)
                                    .padding(.horizontal)
                                
                                ForEach(Array(selection.applicationTokens), id: \.self) { token in
                                    AppTokenRow(token: token)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "tray")
                                .font(.system(size: 40))
                                .foregroundColor(AppColors.textMuted)
                            
                            Text("No apps selected")
                                .font(.subheadline)
                                .foregroundColor(AppColors.textMuted)
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
                            .background(AppColors.primary)
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
                                .background(AppColors.success)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .disabled(selection.applicationTokens.isEmpty && selection.categoryTokens.isEmpty)
                    }
                    .padding()
                }
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
