//
//  QuizService.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import Foundation

protocol QuizServiceProtocol {
    func fetchQuizQuestions() async throws -> [QuizQuestion]
}

class QuizService: QuizServiceProtocol {
    func fetchQuizQuestions() async throws -> [QuizQuestion] {
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay

        return [
            QuizQuestion(
                id: UUID(),
                question: "What is the capital of France?",
                options: ["Paris", "Berlin", "Rome", "Madrid"],
                correctAnswer: "Paris"
            ),
            QuizQuestion(
                id: UUID(),
                question: "Which planet is known as the Red Planet?",
                options: ["Mars", "Jupiter", "Venus", "Saturn"],
                correctAnswer: "Mars"
            )
        ]
    }
    
    func fetchQuizQuestions(for book: Book) async throws -> [QuizQuestion] {
        guard let url = URL(string: "https://api.litloot.com/quizzes") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Only encode the fields the API expects
        let payload = ["title": book.title, "author": book.author]
        request.httpBody = try JSONEncoder().encode(payload)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([QuizQuestion].self, from: data)
    }
}
