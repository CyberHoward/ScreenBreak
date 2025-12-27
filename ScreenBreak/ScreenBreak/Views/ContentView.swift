//
//  ContentView.swift
//  ScreenBreak
//
//  Main app container
//

import SwiftUI
import CoreData
import FamilyControls
import RiveRuntime
import ManagedSettings


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("selectedTab") var selectedTab: Tab = .star
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @EnvironmentObject var launchScreenManager: LaunchScreenManager

    var body: some View {
        ZStack {
            AppColors.bg
            
            // Main app content
            if hasCompletedOnboarding {
                switch selectedTab {
                case .home:
                    HomeView()
                case .star:
                    RequestAccessView()
                case .timer:
                    SettingsView()
                case .search:
                    MoreInsightsView()
                }
                TabBar()
            } else {
                // Show placeholder until onboarding check completes
                Color.clear
            }
        }
        .fullScreenCover(isPresented: .init(
            get: { !hasCompletedOnboarding },
            set: { _ in }
        )) {
            OnboardingContainerView(isOnboardingComplete: $hasCompletedOnboarding)
        }
        .onChange(of: hasCompletedOnboarding) { _, completed in
            if completed {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    launchScreenManager.dismiss()
                }
            }
        }
        .onAppear {
            // Dismiss launch screen if already completed onboarding
            if hasCompletedOnboarding {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    launchScreenManager.dismiss()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(LaunchScreenManager())
    }
}
