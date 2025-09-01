//
//  SearchView.swift
//  DogEar
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var theme: Theme
    @StateObject private var vm = SearchViewModel(service: OpenLibrarySearchService())

    var body: some View {
        NavigationStack {
            ZStack {
                theme.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Search bar (32pt, matches Home tabs)
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(theme.primary)

                        HStack(spacing: 6) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 15))
                                .foregroundStyle(theme.background)

                            TextField(
                                "",
                                text: $vm.query,
                                prompt: Text("Find books, authors, reviews…")
                                    .foregroundStyle(theme.background)
                                    .font(theme.body(15))
                            )
                            .font(theme.body(15))
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .foregroundStyle(theme.background)
                            .tint(theme.background)
                            .onChange(of: vm.query) { _, _ in
                                vm.scheduleSearch()
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                    }
                    .frame(height: 32)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 12)

                    // --- STATES & RESULTS ---
                    Group {
                        if vm.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            // Initial placeholder
                            VStack(spacing: 8) {
                                Text("Search")
                                    .font(theme.title(28))
                                Text("Type to find books, authors, series…")
                                    .font(theme.body(16))
                                    .foregroundStyle(theme.primary.opacity(0.7))
                            }
                            .foregroundStyle(theme.primary)
                            .padding(.top, 80)

                        } else if vm.isLoading {
                            ProgressView()
                                .tint(theme.primary)
                                .padding(.top, 24)

                        } else if let msg = vm.errorMessage {
                            Text(msg)
                                .font(theme.body(15))
                                .foregroundStyle(theme.primary.opacity(0.85))
                                .padding(.top, 24)

                        } else if vm.results.isEmpty {
                            Text("No results found")
                                .font(theme.body(15))
                                .foregroundStyle(theme.primary.opacity(0.8))
                                .padding(.top, 24)

                        } else {
                            List(vm.results) { book in
                                BookRow(book: book, theme: theme)
                                    .listRowBackground(Color.clear)
                            }
                            .listStyle(.plain)
                            .scrollContentBackground(.hidden)
                            .background(theme.background)
                        }
                    }

                    Spacer(minLength: 0)
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
        .onChange(of: vm.results) { _, results in
            let titles = results.map(\.title).joined(separator: ", ")
            print("Search results (\(results.count)): \(titles)")
        }
    }
}

// MARK: - Row UI with cover image
private struct BookRow: View {
    let book: Book
    let theme: Theme

    var body: some View {
        HStack(spacing: 12) {
            // Cover
            ZStack {
                // Placeholder background (shows while loading or when missing)
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(theme.primary.opacity(0.12))

                if let url = book.coverURL {
                    AsyncImage(url: url, transaction: .init(animation: .easeOut(duration: 0.2))) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .transition(.opacity)
                        case .empty:
                            placeholder
                        case .failure(_):
                            placeholder
                        @unknown default:
                            placeholder
                        }
                    }
                } else {
                    placeholder
                }
            }
            .frame(width: 48, height: 68)
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))

            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(theme.body(16).weight(.semibold))
                    .foregroundStyle(theme.primary)
                    .lineLimit(2)

                Text("\(book.author)\(book.year.map { " · \($0)" } ?? "")")
                    .font(theme.body(14))
                    .foregroundStyle(theme.primary.opacity(0.75))
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(.vertical, 6)
    }

    private var placeholder: some View {
        RoundedRectangle(cornerRadius: 6, style: .continuous)
            .fill(theme.primary.opacity(0.12))
    }
}


#Preview {
    NavigationStack { SearchView() }
        .environmentObject(Theme())
}
