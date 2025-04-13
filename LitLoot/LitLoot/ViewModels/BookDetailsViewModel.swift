//
//  BookDetailsViewModel.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import Foundation

@MainActor
final class BookDetailsViewModel: ObservableObject {
    @Published var book: Book
    @Published var quizQuestions: [QuizQuestion] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let quizService: QuizServiceProtocol

    init(book: Book, quizService: QuizServiceProtocol = QuizService()) {
        self.book = book
        self.quizService = quizService
    }

    func loadQuiz() async {
        isLoading = true
        errorMessage = nil
        
        do {
            quizQuestions = try await quizService.fetchQuizQuestions(for: book)
        } catch let error as QuizError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

#if DEBUG
extension BookDetailsViewModel {
    static let preview = BookDetailsViewModel(
        book: Book(
            id: UUID(),
            title: "Test Book",
            author: "Test Author",
            content: "Test Description"
        ),
        quizService: QuizService.mock
    )
}
#endif
