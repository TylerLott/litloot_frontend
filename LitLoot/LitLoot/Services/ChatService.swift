//
//  ChatService.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/13/25.
//

import Foundation

enum ChatError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse(Int)
    case decodingError(Error)
    case noData
    
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
        }
    }
}

struct ChatResponse: Codable {
    let response: String
    let books: [Book]?
}

class ChatService {
    private let baseURL = "http://localhost:5001" // Update with your actual backend URL
    
    func sendMessage(_ message: String) async throws -> ChatResponse {
        guard let url = URL(string: "\(baseURL)/api/chat") else {
            throw ChatError.invalidURL
        }
        
        let body = ["query": message]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            print("Encoding error: \(error)")
            throw ChatError.networkError(error)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ChatError.invalidResponse(-1)
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Server returned status code: \(httpResponse.statusCode)")
                if let errorString = String(data: data, encoding: .utf8) {
                    print("Server response: \(errorString)")
                }
                throw ChatError.invalidResponse(httpResponse.statusCode)
            }
            
            guard !data.isEmpty else {
                throw ChatError.noData
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
                return decodedResponse
            } catch {
                print("Decoding error: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Raw response: \(responseString)")
                }
                throw ChatError.decodingError(error)
            }
        } catch let error as ChatError {
            throw error
        } catch {
            print("Network error: \(error)")
            throw ChatError.networkError(error)
        }
    }
}

#if DEBUG
extension ChatService {
    static let mock = ChatService()
}
#endif
