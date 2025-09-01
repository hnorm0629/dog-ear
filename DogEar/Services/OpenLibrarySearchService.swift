//
//  OpenLibrarySearchService.swift
//  DogEar
//

import Foundation

// Open Library response DTOs (internal to this file)
private struct OLSearchResponse: Decodable { let docs: [OLDoc] }
private struct OLDoc: Decodable {
    let key: String?
    let title: String?
    let author_name: [String]?
    let first_publish_year: Int?
    let cover_i: Int?
}

final class OpenLibrarySearchService: BookSearchService {
    func searchBooks(query: String, page: Int = 1) async throws -> [Book] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }

        guard
            let q = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "https://openlibrary.org/search.json?q=\(q)&page=\(page)&limit=20")
        else { return [] }

        let (data, resp) = try await URLSession.shared.data(from: url)
        guard let http = resp as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(OLSearchResponse.self, from: data)

        return decoded.docs.compactMap { d in
            guard let id = d.key, let title = d.title else { return nil }
            let author = d.author_name?.first ?? "Unknown author"
            let coverURL = d.cover_i.flatMap { URL(string: "https://covers.openlibrary.org/b/id/\($0)-M.jpg") }
            return Book(id: id, title: title, author: author, year: d.first_publish_year, coverURL: coverURL)
        }
    }
}


