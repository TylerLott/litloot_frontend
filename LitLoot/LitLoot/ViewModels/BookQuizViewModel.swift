//
//  BookQuizViewModel.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import Foundation

@MainActor
class BookQuizViewModel: ObservableObject {
    @Published var currentQuestion: QuizQuestion?
    @Published var selectedAnswers: [Int: String] = [:]
    @Published var score: Int = 0
    @Published var isLoading: Bool = false
    @Published var quizComplete: Bool = false
    @Published var error: QuizError?
    @Published var showError: Bool = false

    private(set) var allQuestions: [QuizQuestion] = []
    @Published var currentIndex = 0

    private let quizService: QuizServiceProtocol
    private let book: Book

    init(book: Book, quizService: QuizServiceProtocol = QuizService()) {
        self.book = book
        self.quizService = quizService
    }

    var currentQuestionNumber: Int { currentIndex + 1 }
    var totalQuestions: Int { allQuestions.count }

    func startQuiz() async {
        isLoading = true
        error = nil
        showError = false
        
        do {
            allQuestions = try await quizService.fetchQuizQuestions(for: book)
            score = 0
            currentIndex = 0
            quizComplete = false
            currentQuestion = allQuestions.first
        } catch let error as QuizError {
            self.error = error
            showError = true
        } catch {
            self.error = .networkError(error)
            showError = true
        }
        
        isLoading = false
    }

    func selectAnswer(_ answer: String) {
        selectedAnswers[currentIndex] = answer
    }

    func goToNextQuestion() {
        guard currentIndex + 1 < allQuestions.count else {
            finishQuiz()
            return
        }
        currentIndex += 1
        currentQuestion = allQuestions[currentIndex]
    }

    func goToPreviousQuestion() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        currentQuestion = allQuestions[currentIndex]
    }

    func finishQuiz() {
        quizComplete = true
        score = selectedAnswers.reduce(0) { total, pair in
            let (index, answer) = pair
            return total + (allQuestions[index].correctAnswer == answer ? 1 : 0)
        }
    }

    func selectedAnswerForCurrentQuestion() -> String? {
        selectedAnswers[currentIndex]
    }
}
