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
                                NavigationLink {
                                    BookDetailView(book: book)   // 👈 push detail screen
                                } label: {
                                    BookRow(book: book, theme: theme)
                                }
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


// MARK: - Book Detail (with real data)
private struct BookDetailView: View {
    @EnvironmentObject var theme: Theme
    let book: Book

    @StateObject private var vm: BookDetailViewModel

    init(book: Book) {
        self.book = book
        _vm = StateObject(
            wrappedValue: BookDetailViewModel(
                service: OpenLibraryDetailService(),
                workKey: book.id,
                fallback: book // show basic info immediately, then upgrade
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Header
                HStack(alignment: .top, spacing: 16) {
                    coverView
                        .frame(width: 120, height: 170)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                    VStack(alignment: .leading, spacing: 6) {
                        Text(vm.detail?.title ?? book.title)
                            .font(theme.title(22))
                            .foregroundStyle(theme.primary)
                            .lineLimit(3)

                        Text("\(vm.detail?.author ?? book.author)\( (vm.detail?.year ?? book.year).map { " · \($0)" } ?? "")")
                            .font(theme.body(15))
                            .foregroundStyle(theme.primary.opacity(0.85))
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                // States
                if vm.isLoading && vm.detail == nil {
                    ProgressView()
                        .tint(theme.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)
                } else if let msg = vm.errorMessage, vm.detail == nil {
                    Text(msg)
                        .font(theme.body(15))
                        .foregroundStyle(theme.primary.opacity(0.9))
                }

                // Description
                if let desc = vm.detail?.description, !desc.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Overview")
                            .font(theme.title(18))
                            .foregroundStyle(theme.primary)
                        Text(desc)
                            .font(theme.body(15))
                            .foregroundStyle(theme.primary.opacity(0.9))
                            .lineSpacing(4)
                    }
                } else {
                    // Optional placeholder
                    Text("No description available.")
                        .font(theme.body(15))
                        .foregroundStyle(theme.primary.opacity(0.6))
                }

                // Subjects (chips)
                if let subjects = vm.detail?.subjects, !subjects.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Subjects")
                            .font(theme.title(18))
                            .foregroundStyle(theme.primary)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(subjects.prefix(24), id: \.self) { s in
                                    Text(s)
                                        .font(theme.body(13))
                                        .foregroundStyle(theme.primary)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .fill(theme.primary.opacity(0.12))
                                        )
                                }
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(16)
        }
        .background(theme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Book")
                    .font(theme.title(25))
                    .foregroundStyle(theme.headings)
            }
        }
        .task { await vm.load() } // 🔹 fetch detail on appear
    }

    // MARK: Cover
    private var coverView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(theme.primary.opacity(0.12))

            if let url = (vm.detail?.coverURL ?? book.coverURL) {
                AsyncImage(url: url, transaction: .init(animation: .easeOut(duration: 0.2))) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill().transition(.opacity)
                    case .empty, .failure(_):
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
    }

    private var placeholder: some View {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(theme.primary.opacity(0.12))
    }
}



#Preview {
    NavigationStack { SearchView() }
        .environmentObject(Theme())
}
