//
//  MockBookSearchService.swift
//  DogEar
//

import Foundation

final class MockBookSearchService: BookSearchService {
    private let pageSize = 20

    // Small, deterministic catalog to search over
    private let catalog: [Book] = [
        .init(id: "/works/OL1W",  title: "The Hobbit",                 author: "J. R. R. Tolkien", year: 1937, coverURL: nil),
        .init(id: "/works/OL2W",  title: "Dune",                       author: "Frank Herbert",    year: 1965, coverURL: nil),
        .init(id: "/works/OL3W",  title: "Pride and Prejudice",        author: "Jane Austen",      year: 1813, coverURL: nil),
        .init(id: "/works/OL4W",  title: "The Name of the Wind",       author: "Patrick Rothfuss", year: 2007, coverURL: nil),
        .init(id: "/works/OL5W",  title: "1984",                       author: "George Orwell",    year: 1949, coverURL: nil),
        .init(id: "/works/OL6W",  title: "The Left Hand of Darkness",  author: "Ursula K. Le Guin",year: 1969, coverURL: nil),
        .init(id: "/works/OL7W",  title: "The Catcher in the Rye",     author: "J. D. Salinger",   year: 1951, coverURL: nil),
        .init(id: "/works/OL8W",  title: "The Great Gatsby",           author: "F. Scott Fitzgerald", year: 1925, coverURL: nil),
        .init(id: "/works/OL9W",  title: "The Fellowship of the Ring", author: "J. R. R. Tolkien", year: 1954, coverURL: nil),
        .init(id: "/works/OL10W", title: "Mistborn: The Final Empire", author: "Brandon Sanderson",year: 2006, coverURL: nil)
    ]

    func searchBooks(query: String, page: Int = 1) async throws -> [Book] {
        // simulate debounce/network delay so UI states are testable later
        try? await Task.sleep(nanoseconds: 200_000_000)

        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }

        let q = trimmed.lowercased()
        let filtered = catalog.filter {
            $0.title.lowercased().contains(q) || $0.author.lowercased().contains(q)
        }

        // Simple pagination
        let start = max(0, (page - 1) * pageSize)
        let end = min(filtered.count, start + pageSize)
        return start < end ? Array(filtered[start..<end]) : []
    }
}
