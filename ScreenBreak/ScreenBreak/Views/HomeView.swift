//
//  HomeView.swift
//  ScreenBreak
//
//  Main dashboard showing pact progress and stats
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var showingRequestAccess = false
    
    init() {
        if let font = UIFont(name: "Poppins-Bold", size: 40) {
            UINavigationBar.appearance().largeTitleTextAttributes = [.font: font]
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.bg
                    .ignoresSafeArea()
                
                if viewModel.hasPact {
                    dashboardContent
                } else {
                    noPactView
                }
            }
            .navigationTitle("Dashboard")
            .refreshable {
                viewModel.refresh()
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private var dashboardContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Pact progress card
                PactProgressCard(viewModel: viewModel)
                
                // Today's stats
                TodayStatsCard(viewModel: viewModel)
                
                // Active sessions
                if !viewModel.activeSessions.isEmpty {
                    ActiveSessionsCard(sessions: viewModel.activeSessions)
                }
                
                // Quick actions
                QuickActionsCard(showingRequestAccess: $showingRequestAccess)
            }
            .padding()
        }
        .sheet(isPresented: $showingRequestAccess) {
            RequestAccessView()
        }
    }
    
    private var noPactView: some View {
        VStack(spacing: 24) {
            Image(systemName: "flag.checkered")
                .font(.system(size: 80))
                .foregroundColor(AppColors.textMuted)
            
            Text("No Active Pact")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(AppColors.text)
            
            Text("Complete onboarding to start your journey")
                .font(.body)
                .foregroundColor(AppColors.textMuted)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
