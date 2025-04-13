//
//  MockQuizService.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import Foundation

class MockQuizService: QuizServiceProtocol {
    var shouldSucceed: Bool = true
    var delay: TimeInterval = 1.0
    
    func fetchQuizQuestions() async throws -> [QuizQuestion] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        
        if shouldSucceed {
            return [
                QuizQuestion(
                    id: UUID(),
                    question: "Who wrote 'Pride and Prejudice'?",
                    options: ["Jane Austen", "Emily Brontë", "Charlotte Brontë", "Virginia Woolf"],
                    correctAnswer: "Jane Austen"
                ),
                QuizQuestion(
                    id: UUID(),
                    question: "In which year was '1984' published?",
                    options: ["1949", "1950", "1948", "1951"],
                    correctAnswer: "1949"
                ),
                QuizQuestion(
                    id: UUID(),
                    question: "What is the name of the protagonist in 'The Great Gatsby'?",
                    options: ["Nick Carraway", "Jay Gatsby", "Tom Buchanan", "George Wilson"],
                    correctAnswer: "Nick Carraway"
                )
            ]
        } else {
            throw QuizError.networkError(NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock network error"]))
        }
    }
    
    func fetchQuizQuestions(for book: Book) async throws -> [QuizQuestion] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        
        if shouldSucceed {
            return [
                QuizQuestion(
                    id: UUID(),
                    question: "What is a major theme in '\(book.title)'?",
                    options: ["Love and Loss", "Power and Corruption", "Identity and Growth", "Family Dynamics"],
                    correctAnswer: "Love and Loss"
                ),
                QuizQuestion(
                    id: UUID(),
                    question: "Who is the author of '\(book.title)'?",
                    options: [book.author, "Unknown Author", "Anonymous", "Multiple Authors"],
                    correctAnswer: book.author
                ),
                QuizQuestion(
                    id: UUID(),
                    question: "What genre is '\(book.title)' primarily associated with?",
                    options: ["Fiction", "Non-fiction", "Poetry", "Drama"],
                    correctAnswer: "Fiction"
                )
            ]
        } else {
            throw QuizError.networkError(NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock network error"]))
        }
    }
}
