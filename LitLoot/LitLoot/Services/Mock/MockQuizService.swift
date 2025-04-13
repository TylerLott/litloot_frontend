//
//  MockQuizService.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import Foundation

class MockQuizService: QuizServiceProtocol {
    func fetchQuizQuestions() async throws -> [QuizQuestion] {
        return [
            QuizQuestion(
                id: UUID(),
                question: "Preview Question: What is 2 + 2?",
                options: ["3", "4", "5", "6"],
                correctAnswer: "4"
            )
        ]
    }
}
