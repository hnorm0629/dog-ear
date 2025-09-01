//
//  SearchView.swift
//  DogEar
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var theme: Theme
    @State private var query = ""

    var body: some View {
        NavigationStack {
            ZStack {
                theme.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Search bar positioned right below toolbar
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(theme.background)

                        TextField(
                            "",
                            text: $query,
                            prompt: Text("Find books, authors, reviews…")
                                .foregroundStyle(theme.background)
                        )
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .foregroundStyle(theme.background)
                        .tint(theme.background)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(theme.primary)
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 20)

                    // Page content area
                    VStack(spacing: 8) {
                        Text("Search")
                            .font(theme.title(28))
                            .padding(.top, 100)
                        Text("Type to find books, authors, series…")
                            .font(theme.body(16))
                            .foregroundStyle(theme.primary.opacity(0.7))
                    }
                    .foregroundStyle(theme.primary)

                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Search")
                        .font(theme.title(25))
                        .foregroundStyle(theme.headings)
                }
            }
        }
    }
}

#Preview {
    NavigationStack { SearchView() }
        .environmentObject(Theme())
}
