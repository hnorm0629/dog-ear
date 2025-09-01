//
//  ActivityView.swift
//  DogEar
//

import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var theme: Theme

    var body: some View {
        NavigationStack {
            ZStack {
                theme.background.ignoresSafeArea()

                VStack(spacing: 16) {
                    Text("Activity")
                        .font(theme.title(28))
                    Text("See what your friends are reading and rating.")
                        .font(theme.body(16))
                }
                .padding()
                .foregroundStyle(theme.primary)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Activity")
                        .font(theme.title(25))
                        .foregroundStyle(theme.primary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack { ActivityView() }
        .environmentObject(Theme())
}


