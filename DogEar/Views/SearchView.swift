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
                    // Search bar (match Home tabs: height 32, small padding, body(15) text)
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(theme.primary)

                        HStack(spacing: 6) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 15))                  // not semibold
                                .foregroundStyle(theme.background)

                            TextField(
                                "",
                                text: $query,
                                prompt: Text("Find books, authors, reviews…")
                                    .foregroundStyle(theme.background)
                                    .font(theme.body(15))
                            )
                            .font(theme.body(15))                        // match tab text
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .foregroundStyle(theme.background)           // typed text color
                            .tint(theme.background)                      // cursor color
                        }
                        .padding(.horizontal, 8)                         // small like tabs
                        .padding(.vertical, 2)
                    }
                    .frame(height: 32)                                   // exact height
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
