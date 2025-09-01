//
//  HomeView.swift
//  DogEar
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var theme: Theme

    private enum HomeTab: String, CaseIterable { case books = "Books", reviews = "Reviews", lists = "Shelves" }
    @State private var tab: HomeTab = .books
    @Namespace private var tabNS

    // Match this to your SearchView bar height
    private let barHeight: CGFloat = 32

    var body: some View {
        NavigationStack {
            ZStack {
                theme.background.ignoresSafeArea()

                // Page content area (below the tabs)
                VStack(spacing: 12) {
                    switch tab {
                    case .books:
                        BooksPane(theme: theme)
                    case .reviews:
                        ReviewsPane(theme: theme)
                    case .lists:
                        ListsPane(theme: theme)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Dog Ear")
                        .font(theme.title(25))
                        .foregroundStyle(theme.headings)
                }
            }

            .safeAreaInset(edge: .top) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(theme.primary)
                    HStack(spacing: 6) {
                        ForEach(HomeTab.allCases, id: \.self) { t in
                            ZStack {
                                if tab == t {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(theme.background)
                                        .matchedGeometryEffect(id: "tabHighlight", in: tabNS)
                                }
                                Text(t.rawValue)
                                    .font(theme.body(15))
                                    .foregroundStyle(tab == t ? theme.primary : theme.background.opacity(0.85))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .onTapGesture {
                                withAnimation(.spring(response: 0.28, dampingFraction: 0.86)) {
                                    tab = t
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 2)
                    .padding(.vertical, 2)
                }
                .frame(height: barHeight)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .background(theme.background)
            }
        }
    }
}

// MARK: - Tab panes (placeholder content)
private struct BooksPane: View {
    let theme: Theme
    var body: some View {
        VStack(spacing: 8) {
            Text("Trending Books").font(theme.title(22)).foregroundStyle(theme.primary)
            Text("Popular picks across genres, refreshed daily.")
                .font(theme.body(15)).foregroundStyle(theme.primary.opacity(0.75))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 100)
    }
}

private struct ReviewsPane: View {
    let theme: Theme
    var body: some View {
        VStack(spacing: 8) {
            Text("Latest Reviews").font(theme.title(22)).foregroundStyle(theme.primary)
            Text("What readers are saying this week.")
                .font(theme.body(15)).foregroundStyle(theme.primary.opacity(0.75))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 100)
    }
}

private struct ListsPane: View {
    let theme: Theme
    var body: some View {
        VStack(spacing: 8) {
            Text("Curated Shelves").font(theme.title(22)).foregroundStyle(theme.primary)
            Text("Staff picks, series orders, and seasonal themes.")
                .font(theme.body(15)).foregroundStyle(theme.primary.opacity(0.75))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 100)
    }
}
#Preview {
    NavigationStack { HomeView() }
        .environmentObject(Theme())
}
