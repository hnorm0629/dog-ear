//
//  BookDetail.swift
//  DogEar
//

import Foundation

struct BookDetail: Identifiable, Hashable {
    let id: String            // same work key as Book.id
    let title: String
    let author: String
    let year: Int?
    let description: String?
    let subjects: [String]
    let coverURL: URL?        // can use a larger size for detail view
}


