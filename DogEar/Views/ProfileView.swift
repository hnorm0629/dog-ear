//
//  ProfileView.swift
//  DogEar
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var theme: Theme

    var body: some View {
        NavigationStack {
            ZStack {
                theme.background.ignoresSafeArea()

                VStack(spacing: 16) {
                    Text("Profile")
                        .font(theme.title(28))
                    Text("Your diary, ratings, and lists will show here.")
                        .font(theme.body(16))
                }
                .padding()
                .foregroundStyle(theme.primary)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Profile")
                        .font(theme.title(25))
                        .foregroundStyle(theme.primary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack { ProfileView() }
        .environmentObject(Theme())
}
