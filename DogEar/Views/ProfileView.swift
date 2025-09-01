//
//  ProfileView.swift
//  DogEar
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var theme: Theme
    var body: some View {
        NavigationStack {
            Text("Profile goes here")
                .font(theme.body(16))
                .navigationTitle("Profile")
        }
    }
}

#Preview {
    NavigationStack { HomeView() }
        .environmentObject(Theme())
}
