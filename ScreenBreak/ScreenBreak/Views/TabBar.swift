//
//  TabBar.swift
//  ScreenBreak
//
//  Created by Christian Pichardo on 3/7/23.
//

import SwiftUI

struct TabBar: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .star
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Fade effect at top instead of hard line
            LinearGradient(
                colors: [
                    AppColors.bgDark.opacity(0),
                    AppColors.bgDark.opacity(0.6),
                    AppColors.bgDark
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 20)
            
            // Tab bar content
            HStack(spacing: 0) {
                ForEach(tabItems) { item in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = item.tab
                        }
                    } label: {
                        Image(systemName: item.iconName)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(
                                selectedTab == item.tab
                                    ? (colorScheme == .dark ? AppColors.text : AppColors.text)
                                    : AppColors.textMuted.opacity(0.5)
                            )
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .scaleEffect(selectedTab == item.tab ? 1.1 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedTab)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
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
    var iconName: String
    var tab: Tab
}

var tabItems = [
    TabItem(iconName: "house.fill", tab: .home),
    TabItem(iconName: "star.fill", tab: .star),
    TabItem(iconName: "timer", tab: .timer),
    TabItem(iconName: "magnifyingglass", tab: .search)
]

enum Tab: String {
    case home
    case star
    case timer
    case search
}
