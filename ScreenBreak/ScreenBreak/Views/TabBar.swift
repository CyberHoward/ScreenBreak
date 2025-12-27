//
//  TabBar.swift
//  ScreenBreak
//
//  Created by Christian Pichardo on 3/7/23.
//

import SwiftUI
import RiveRuntime

struct TabBar: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .star
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Top border line
            Rectangle()
                .fill(AppColors.borderMuted)
                .frame(height: 1)
            
            // Tab bar content
            HStack(spacing: 0) {
                ForEach(tabItems) { item in
                    Button {
                        try? item.icon.setInput("active", value: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            try? item.icon.setInput("active", value: false)
                        }
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = item.tab
                        }
                    } label: {
                        VStack(spacing: 4) {
                            // Active indicator
                            RoundedRectangle(cornerRadius: 2)
                                .fill(AppColors.highlight)
                                .frame(width: selectedTab == item.tab ? 24 : 0, height: 3)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
                            
                            // Icon
                            item.icon.view()
                                .frame(width: 28, height: 28)
                                .opacity(selectedTab == item.tab ? 1 : 0.4)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            .background(AppColors.bgDark)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}

struct TabItem: Identifiable {
    var id = UUID()
    var icon: RiveViewModel
    var tab: Tab
}

var tabItems = [
    TabItem(icon: RiveViewModel(fileName: "icons", stateMachineName: "HOME_interactivity", artboardName: "HOME"), tab: .home),
    TabItem(icon: RiveViewModel(fileName: "icons", stateMachineName: "STAR_Interactivity", artboardName: "LIKE/STAR"), tab: .star),
    TabItem(icon: RiveViewModel(fileName: "icons", stateMachineName: "TIMER_Interactivity", artboardName: "TIMER"), tab: .timer),
    TabItem(icon: RiveViewModel(fileName: "icons", stateMachineName: "SEARCH_Interactivity", artboardName: "SEARCH"), tab: .search)
]

enum Tab: String {
    case home
    case star
    case timer
    case search
}
