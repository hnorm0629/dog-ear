//
//  ProfileView.swift
//  DogEar
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var theme: Theme

    private enum ProfileTab: String, CaseIterable { case profile = "Profile", diary = "Diary", shelves = "Shelves", readlist = "Readlist" }
    @State private var tab: ProfileTab = .profile
    @Namespace private var tabNS

    // Match SearchView/HomeView bar height
    private let barHeight: CGFloat = 32

    var body: some View {
        NavigationStack {
            ZStack {
                theme.background.ignoresSafeArea()

                // Page content area (below the tabs)
                VStack(spacing: 12) {
                    switch tab {
                    case .profile:
                        ProfilePane(theme: theme)
                    case .diary:
                        DiaryPane(theme: theme)
                    case .shelves:
                        ShelvesPane(theme: theme)
                    case .readlist:
                        ReadlistPane(theme: theme)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Profile")
                        .font(theme.title(25))
                        .foregroundStyle(theme.headings)
                }
            }

            // Internal tabs pinned under the nav bar
            .safeAreaInset(edge: .top) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(theme.primary)
                    HStack(spacing: 6) {
                        ForEach(ProfileTab.allCases, id: \.self) { t in
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
private struct ProfilePane: View {
    let theme: Theme
    var body: some View {
        VStack(spacing: 8) {
            Text("Your Profile").font(theme.title(22)).foregroundStyle(theme.primary)
            Text("Basic info, avatar, and stats.")
                .font(theme.body(15)).foregroundStyle(theme.primary.opacity(0.75))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 100)
    }
}

private struct DiaryPane: View {
    let theme: Theme
    var body: some View {
        VStack(spacing: 8) {
            Text("Reading Diary").font(theme.title(22)).foregroundStyle(theme.primary)
            Text("Daily notes, highlights, and reflections.")
                .font(theme.body(15)).foregroundStyle(theme.primary.opacity(0.75))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 100)
    }
}

private struct ShelvesPane: View {
    let theme: Theme
    var body: some View {
        VStack(spacing: 8) {
            Text("Your Shelves").font(theme.title(22)).foregroundStyle(theme.primary)
            Text("Organize by genre, status, or custom tags.")
                .font(theme.body(15)).foregroundStyle(theme.primary.opacity(0.75))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 100)
    }
}

private struct ReadlistPane: View {
    let theme: Theme
    var body: some View {
        VStack(spacing: 8) {
            Text("Readlist").font(theme.title(22)).foregroundStyle(theme.primary)
            Text("Queue up what to read next.")
                .font(theme.body(15)).foregroundStyle(theme.primary.opacity(0.75))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 100)
    }
}

#Preview {
    NavigationStack { ProfileView() }
        .environmentObject(Theme())
}
