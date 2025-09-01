//
//  RootTabView.swift
//  DogEar
//

import SwiftUI

struct RootTabView: View {
    @EnvironmentObject var theme: Theme
    @State private var selection: Tab = .home

    enum Tab: Int { case home, search, add, activity, profile }

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "Background")
        let unselected = UIColor(named: "TextPrimary")?.withAlphaComponent(0.6)
        appearance.stackedLayoutAppearance.normal.iconColor = unselected
        appearance.inlineLayoutAppearance.normal.iconColor  = unselected
        appearance.compactInlineLayoutAppearance.normal.iconColor = unselected
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().unselectedItemTintColor = unselected
    }

    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Image(systemName: "books.vertical")
                        .accessibilityLabel("Home")
                }
                .tag(Tab.home)

            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass.circle")
                        .accessibilityLabel("Search")
                }
                .tag(Tab.search)

            AddView()
                .tabItem {
                    Image(systemName: "plus.app")
                        .accessibilityLabel("Add to Library")
                }
                .tag(Tab.add)

            ActivityView()
                .tabItem {
                    Image(systemName: "bolt")
                        .accessibilityLabel("Friends Activity")
                }
                .tag(Tab.activity)

            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                        .symbolVariant(.none)
                        .symbolRenderingMode(.monochrome)
                        .accessibilityLabel("Profile")
                }
                .tag(Tab.profile)
        }
        .tint(theme.accent)
    }
}

#Preview {
    RootTabView()
        .environmentObject(Theme())
        .preferredColorScheme(.dark)
}
