//
//  QuizService.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import Foundation

enum QuizError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse(Int)
    case decodingError(Error)
    case noData
    case noValidQuestions
    case bookNotFound(String)
    case quizGenerationFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL: Could not construct URL from baseURL"
        case .networkError(let error):
            return "Network Error: \(error.localizedDescription)"
        case .invalidResponse(let statusCode):
            return "Server Error: Received status code \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .noData:
            return "Server returned no data"
        case .noValidQuestions:
            return "No valid questions were generated for this book"
        case .bookNotFound(let bookTitle):
            return "No books found matching '\(bookTitle)'"
        case .quizGenerationFailed(let error):
            return "Failed to generate quiz: \(error)"
        }
    }
}

protocol QuizServiceProtocol {
    func fetchQuizQuestions() async throws -> [QuizQuestion]
    func fetchQuizQuestions(for book: Book) async throws -> [QuizQuestion]
}

// Backend response structures
private struct QuizResponse: Codable {
    let book: String
    let questions: [BackendQuestion]
    let error: String?
}

private struct BackendQuestion: Codable {
    let question: String
    let answers: [String]
    let correctIndex: Int
    let difficulty: String
    let type: String
}

class QuizService: QuizServiceProtocol {
    private let baseURL = "http://localhost:5001"
    
    func fetchQuizQuestions() async throws -> [QuizQuestion] {
        // This is just a fallback for testing
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
        guard let url = URL(string: "\(baseURL)/api/quiz") else {
            throw QuizError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = ["query": book.title]
        
        do {
            request.httpBody = try JSONEncoder().encode(payload)
        } catch {
            print("Encoding error: \(error)")
            throw QuizError.networkError(error)
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw QuizError.invalidResponse(-1)
            }
            
            guard !data.isEmpty else {
                throw QuizError.noData
            }
            
            // Print raw response for debugging
            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw response: \(responseString)")
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let backendResponse = try decoder.decode(QuizResponse.self, from: data)
                
                // Handle backend errors
                if let error = backendResponse.error {
                    if httpResponse.statusCode == 404 {
                        throw QuizError.bookNotFound(book.title)
                    } else {
                        throw QuizError.quizGenerationFailed(error)
                    }
                }
                
                // Filter out error questions and convert to our model
                let validQuestions = backendResponse.questions
                    .filter { $0.type != "error" && $0.question != "Could not generate a structured quiz." }
                    .map { backendQuestion in
                        QuizQuestion(
                            id: UUID(),
                            question: backendQuestion.question,
                            options: backendQuestion.answers,
                            correctAnswer: backendQuestion.answers[backendQuestion.correctIndex]
                        )
                    }
                
                guard !validQuestions.isEmpty else {
                    throw QuizError.noValidQuestions
                }
                
                return validQuestions
                
            } catch let error as QuizError {
                throw error
            } catch {
                print("Decoding error: \(error)")
                throw QuizError.decodingError(error)
            }
        } catch let error as QuizError {
            throw error
        } catch {
            print("Network error: \(error)")
            throw QuizError.networkError(error)
        }
    }
}

#if DEBUG
extension QuizService {
    static let mock = MockQuizService()
}
#endif
