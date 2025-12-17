//
//  ScreenBreakApp.swift
//  ScreenBreak
//
//  Main app entry point
//

import SwiftUI
import DeviceActivity
import FamilyControls
import ManagedSettings

@main
struct ScreenBreakApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var launchScreenManager = LaunchScreenManager()
    @StateObject var model = MyModel.shared
    @State var isReady = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isReady {
                    ContentView()
                        .environmentObject(model)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                } else {
                    STProgressView()
                }
                
                if launchScreenManager.state != .completed {
                    LaunchScreenView()
                }
            }
            .environmentObject(launchScreenManager)
            .onAppear {
                // Initialize services
                _ = ShieldManagementService.shared
                _ = SessionMonitorService.shared
                
                // Small delay to show launch screen
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isReady = true
                }
            }
        }
    }
}

struct STProgressView: View {
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)
                
                Text("Loading ScreenBreak...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
