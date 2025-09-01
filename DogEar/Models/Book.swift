//
//  Book.swift
//  DogEar
//

import Foundation

struct Book: Identifiable, Hashable {
    let id: String          // e.g. "/works/OL12345W"
    let title: String
    let author: String
    let year: Int?
    let coverURL: URL?
}
