//
//  HomeView.swift
//  DogEar
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var theme: Theme
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Full-screen background
                theme.background
                    .ignoresSafeArea()
                
                // Content
                VStack(spacing: 16) {
                    Text("Home")
                        .font(theme.title(28))
                    Text("This will show trending/popular books.")
                        .font(theme.body(16))
                }
                .padding()
                .foregroundStyle(theme.primary) // default text color
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Dog Ear")
                        .font(theme.title(25))
                        .foregroundStyle(theme.headings)
                }
            }
        }
    }
}

#Preview {
    NavigationStack { HomeView() }
        .environmentObject(Theme())
}

