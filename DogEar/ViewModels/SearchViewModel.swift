//
//  SearchViewModel.swift
//  DogEar
//

import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var results: [Book] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service: BookSearchService
    private var debounceTask: Task<Void, Never>?

    init(service: BookSearchService) {
        self.service = service
    }

    deinit {
        debounceTask?.cancel()
    }

    // Debounce typing before actually searching.
    func scheduleSearch() {
        debounceTask?.cancel()

        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            results = []
            isLoading = false
            errorMessage = nil
            return
        }

        debounceTask = Task { [weak self] in
            // 300ms debounce
            try? await Task.sleep(nanoseconds: 300_000_000)
            guard let self = self, !Task.isCancelled else { return }
            await self.performSearch()
        }
    }

    // Perform the search (can be called directly for tests).
    func performSearch(page: Int = 1) async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            results = []
            return
        }

        isLoading = true
        errorMessage = nil
        do {
            let items = try await service.searchBooks(query: trimmed, page: page)
            results = items
        } catch {
            errorMessage = "Search failed. Please try again."
            results = []
        }
        isLoading = false
    }
}
