//
//  QuizQuestion.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import Foundation

struct QuizQuestion: Identifiable, Codable, Equatable {
    let id: UUID
    let question: String
    let options: [String]
    let correctAnswer: String
}

extension QuizQuestion {
    static let example = QuizQuestion(
        id: UUID(),
        question: "Who wrote 1984?",
        options: ["George Orwell", "Aldous Huxley", "Ray Bradbury", "J.K. Rowling"],
        correctAnswer: "George Orwell"
    )
}
