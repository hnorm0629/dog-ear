//
//  RootTabView.swift
//  DogEar
//
//  Created by Hannah Norman on 8/31/25.
//

import SwiftUI

struct RootTabView: View {
    @EnvironmentObject var theme: Theme

    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }

            SearchView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
        .tint(theme.accent)
        .background(theme.background.ignoresSafeArea())
    }
}


#Preview {
    RootTabView()
        .environmentObject(Theme())     // so your fonts/colors load
        .preferredColorScheme(.dark)     // optional: see your palette in dark
}
