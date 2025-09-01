//
//  BookDetailViewModel.swift
//  DogEar
//

import Foundation

@MainActor
final class BookDetailViewModel: ObservableObject {
    @Published var detail: BookDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service: BookDetailService
    private let workKey: String
    private let fallback: Book?

    init(service: BookDetailService, workKey: String, fallback: Book? = nil) {
        self.service = service
        self.workKey = workKey
        self.fallback = fallback

        // Optional: prefill with lightweight data so UI has something
        if let fb = fallback {
            self.detail = BookDetail(
                id: fb.id,
                title: fb.title,
                author: fb.author,
                year: fb.year,
                description: nil,
                subjects: [],
                coverURL: fb.coverURL // real service may upgrade to larger cover
            )
        }
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            let rich = try await service.fetchDetail(workKey: workKey)
            self.detail = rich
        } catch {
            self.errorMessage = "Couldn’t load book details. Please try again."
        }
        isLoading = false
    }
}
