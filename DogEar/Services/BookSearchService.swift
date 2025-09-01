//
//  BookSearchService.swift
//  DogEar
//

import Foundation

protocol BookSearchService {
    // Search for books matching `query` (1-based `page` for future pagination).
    func searchBooks(query: String, page: Int) async throws -> [Book]
}
