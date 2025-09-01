//
//  AddView.swift
//  DogEar
//

import SwiftUI

struct AddView: View {
    @EnvironmentObject var theme: Theme

    var body: some View {
        NavigationStack {
            ZStack {
                theme.background.ignoresSafeArea()

                VStack(spacing: 16) {
                    Text("Add to Library")
                        .font(theme.title(28))
                    Text("Quickly log a book or add to your lists.")
                        .font(theme.body(16))
                }
                .padding()
                .foregroundStyle(theme.primary)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add")
                        .font(theme.title(25))
                        .foregroundStyle(theme.headings)
                }
            }
        }
    }
}

#Preview {
    NavigationStack { AddView() }
        .environmentObject(Theme())
}
