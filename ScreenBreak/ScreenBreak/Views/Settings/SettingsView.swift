//
//  SettingsView.swift
//  ScreenBreak
//
//  Main settings screen
//

import SwiftUI

struct SettingsView: View {
    @State private var viewModel = SettingsViewModel()
    @State private var showingManageApps = false
    @State private var showingEndPactAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                List {
                    // Pact info section
                    if let pact = viewModel.activePact {
                        Section("Current Pact") {
                            HStack {
                                Text("Duration")
                                Spacer()
                                Text("\(pact.durationDays) days")
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack {
                                Text("Day")
                                Spacer()
                                Text("\(pact.currentDay) of \(pact.durationDays)")
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack {
                                Text("Streak")
                                Spacer()
                                Text("\(pact.streak) days")
                                    .foregroundColor(.orange)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Motivation")
                                Text(pact.motivation)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .italic()
                            }
                        }
                        
                        // Rules section
                        Section("Pact Rules") {
                            HStack {
                                Label("Daily Limit", systemImage: "clock")
                                Spacer()
                                Text("\(pact.rules.dailyLimitMinutes) min")
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack {
                                Label("Session Limit", systemImage: "timer")
                                Spacer()
                                Text("\(pact.rules.sessionLimitMinutes) min")
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack {
                                Label("Strictness", systemImage: "shield")
                                Spacer()
                                Text(pact.rules.strictness.rawValue.capitalized)
                                    .foregroundColor(.secondary)
                            }
                            
                            if let quietHours = pact.rules.quietHours {
                                HStack {
                                    Label("Quiet Hours", systemImage: "moon.stars")
                                    Spacer()
                                    Text(quietHours.description)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    
                    // App management
                    Section("Shielded Apps") {
                        Button(action: {
                            showingManageApps = true
                        }) {
                            HStack {
                                Label("Manage Apps", systemImage: "apps.iphone")
                                Spacer()
                                Text("\(viewModel.shieldedApps.count)")
                                    .foregroundColor(.secondary)
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Authorization status
                    Section("Permissions") {
                        HStack {
                            Label("Screen Time", systemImage: "hourglass")
                            Spacer()
                            Text(viewModel.authorizationStatus)
                                .foregroundColor(viewModel.isAuthorized ? .green : .red)
                        }
                        
                        if !viewModel.isAuthorized {
                            Text("Go to Settings > Screen Time to grant permission")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Danger zone
                    if viewModel.activePact != nil {
                        Section("Danger Zone") {
                            Button(role: .destructive, action: {
                                showingEndPactAlert = true
                            }) {
                                Label("End Pact Early", systemImage: "xmark.circle")
                            }
                        }
                    }
                    
                    // App info
                    Section("About") {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.0.0")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingManageApps) {
                ManageAppsView(viewModel: viewModel)
            }
            .alert("End Pact Early?", isPresented: $showingEndPactAlert) {
                Button("Cancel", role: .cancel) {}
                Button("End Pact", role: .destructive) {
                    Task {
                        await viewModel.endPact()
                    }
                }
            } message: {
                Text("This will end your current pact and remove all shields. Your progress will be lost.")
            }
        }
    }
}

#Preview {
    SettingsView()
}
