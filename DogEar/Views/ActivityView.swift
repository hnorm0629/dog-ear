//
//  HomeView.swift
//  DogEar
//

import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var theme: Theme

    private enum ActivityTab: String, CaseIterable { case books = "Friends", reviews = "You", lists = "Incoming" }
    @State private var tab: ActivityTab = .books
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
                    Text("Activity")
                        .font(theme.title(25))
                        .foregroundStyle(theme.headings)
                }
            }

            .safeAreaInset(edge: .top) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(theme.primary)
                    HStack(spacing: 6) {
                        ForEach(ActivityTab.allCases, id: \.self) { t in
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
            Text("Friends").font(theme.title(22)).foregroundStyle(theme.primary)
            Text("Activity feed for your friends.")
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
            Text("You").font(theme.title(22)).foregroundStyle(theme.primary)
            Text("Your personal activity.")
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
            Text("Incoming").font(theme.title(22)).foregroundStyle(theme.primary)
            Text("Friend requests and other notifications.")
                .font(theme.body(15)).foregroundStyle(theme.primary.opacity(0.75))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 100)
    }
}
#Preview {
    NavigationStack { ActivityView() }
        .environmentObject(Theme())
}
