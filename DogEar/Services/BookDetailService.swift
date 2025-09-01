//
//  BookDetailService.swift
//  DogEar
//

import Foundation

protocol BookDetailService {
    // Fetch rich detail for a work by its Open Library work key (e.g. "/works/OL12345W").
    func fetchDetail(workKey: String) async throws -> BookDetail
}

