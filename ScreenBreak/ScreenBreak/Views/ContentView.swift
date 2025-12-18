//
//  ContentView.swift
//  ScreenBreak
//
//  Main app container
//
//  MINIMAL BUILD VERSION - FamilyControls imports commented out

import SwiftUI
import CoreData
// import FamilyControls  // Commented out for minimal build
import RiveRuntime
// import ManagedSettings  // Commented out for minimal build


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("selectedTab") var selectedTab: Tab = .star
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @EnvironmentObject var launchScreenManager: LaunchScreenManager
    @State private var showOnboarding = false

    var body: some View {
        ZStack{
            Color("backgroundColor")
            
            // Main app content
            if hasCompletedOnboarding {
                switch selectedTab{
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
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingContainerView(isOnboardingComplete: $hasCompletedOnboarding)
        }
        .onAppear {
            // Check if user has completed onboarding
            if !hasCompletedOnboarding {
                showOnboarding = true
            } else {
                DispatchQueue
                    .main
                    .asyncAfter(deadline: .now() + 2) {
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
