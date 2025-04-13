//
//  BookService.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import Foundation

protocol BookServiceProtocol {
    func fetchBooks() async throws -> [Book]
}

class BookService: BookServiceProtocol {
    func fetchBooks() async throws -> [Book] {
        // Replace with real API call later
        return [
            Book(id: UUID(), title: "1984", author: "George Orwell", description: "A dystopian future of surveillance.")
        ]
    }
    
    func fetchBooks_real() async throws -> [Book] {
        guard let url = URL(string: "https://api.litloot.com/books") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Send an empty JSON body for now
        request.httpBody = try JSONEncoder().encode([String: String]())

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        return try decoder.decode([Book].self, from: data)
    }
}
