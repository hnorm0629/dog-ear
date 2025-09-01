//
//  OpenLibraryDetailService.swift
//  DogEar
//

import Foundation

// MARK: - Open Library DTOs (scoped to this file)

private struct OLWorkDetail: Decodable {
    let key: String?
    let title: String?
    let description: OLDescription?
    let subjects: [String]?
    let covers: [Int]?
    let authors: [OLWorkAuthorRef]?
    let first_publish_date: String?
}

private struct OLWorkAuthorRef: Decodable {
    let author: OLKeyRef
}

private struct OLKeyRef: Decodable {
    let key: String   // e.g. "/authors/OL23919A"
}

private enum OLDescription: Decodable {
    case string(String)
    case object(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let s = try? container.decode(String.self) {
            self = .string(s)
            return
        }
        // Sometimes description is { "value": "text..." }
        struct Obj: Decodable { let value: String? }
        let obj = try container.decode(Obj.self)
        self = .object(obj.value ?? "")
    }

    var text: String {
        switch self {
        case .string(let s): return s
        case .object(let s): return s
        }
    }
}

private struct OLAuthorDetail: Decodable {
    let name: String?
}

// MARK: - Service

final class OpenLibraryDetailService: BookDetailService {

    func fetchDetail(workKey: String) async throws -> BookDetail {
        // Normalize key -> "/works/OL...W"
        let normalized = workKey.hasPrefix("/") ? workKey : "/\(workKey)"
        guard let url = URL(string: "https://openlibrary.org\(normalized).json") else {
            throw URLError(.badURL)
        }

        // Fetch work JSON
        let (data, resp) = try await URLSession.shared.data(from: url)
        guard let http = resp as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }
        let work = try JSONDecoder().decode(OLWorkDetail.self, from: data)

        // Author name: fetch first author (if present). If not, fallback.
        var authorName = "Unknown author"
        if let authorKey = work.authors?.first?.author.key,
           let authorURL = URL(string: "https://openlibrary.org\(authorKey).json") {
            do {
                let (ad, ar) = try await URLSession.shared.data(from: authorURL)
                if let http2 = ar as? HTTPURLResponse, 200..<300 ~= http2.statusCode {
                    let author = try JSONDecoder().decode(OLAuthorDetail.self, from: ad)
                    if let n = author.name, !n.isEmpty { authorName = n }
                }
            } catch {
                // Non-fatal; keep fallback
            }
        }

        // Description text (if any)
        let description = work.description?.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let nonEmptyDescription = (description?.isEmpty == false) ? description : nil

        // Subjects
        let subjects = work.subjects ?? []

        // Cover URL (prefer a larger size for detail)
        let coverURL: URL? = {
            guard let id = work.covers?.first else { return nil }
            return URL(string: "https://covers.openlibrary.org/b/id/\(id)-L.jpg")
        }()

        // Year (best-effort parse from first_publish_date like "1954" or "1954-07-29")
        let year: Int? = {
            guard let d = work.first_publish_date else { return nil }
            let prefix = d.prefix(4)
            return Int(prefix)
        }()

        return BookDetail(
            id: work.key ?? normalized,
            title: work.title ?? "Unknown title",
            author: authorName,
            year: year,
            description: nonEmptyDescription,
            subjects: subjects,
            coverURL: coverURL
        )
    }
}


