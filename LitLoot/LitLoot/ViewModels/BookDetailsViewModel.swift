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
            quizQuestions = try await quizService.fetchQuizQuestions()
        } catch {
            errorMessage = "Failed to load quiz."
        }
        isLoading = false
    }
}
