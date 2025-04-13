//
//  AIChatViewModel.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class AIChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var inputText: String = ""
    @Published var isTyping: Bool = false
    @Published var animatingMessageID: UUID? = nil
    @Published var selectedBook: Book? = nil
    
    private let chatService: ChatService
    
    init(chatService: ChatService = ChatService()) {
        self.chatService = chatService
    }

    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = Message(text: inputText, isUser: true)
        messages.append(userMessage)
        let messageToSend = inputText
        inputText = ""

        isTyping = true

        Task {
            do {
                let response = try await chatService.sendMessage(messageToSend)
                let chatMessage = Message(
                    text: response.response,
                    isUser: false,
                    books: response.books
                )
                
                await MainActor.run {
                    self.isTyping = false
                    self.messages.append(chatMessage)
                    self.animatingMessageID = chatMessage.id

                    // Clear animating flag after typing animation completes
                    let animationDuration = Double(response.response.count) * 0.03
                    DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration + 0.3) {
                        self.animatingMessageID = nil
                    }
                }
            } catch let error as ChatError {
                print("Chat error: \(error.localizedDescription)")
                await MainActor.run {
                    self.isTyping = false
                    let errorMessage = Message(
                        text: "Error: \(error.localizedDescription)",
                        isUser: false
                    )
                    self.messages.append(errorMessage)
                }
            } catch {
                print("Unexpected error: \(error)")
                await MainActor.run {
                    self.isTyping = false
                    let errorMessage = Message(
                        text: "An unexpected error occurred. Please try again.",
                        isUser: false
                    )
                    self.messages.append(errorMessage)
                }
            }
        }
    }
    
    func selectBook(_ book: Book) {
        selectedBook = book
    }
    
    func clearSelectedBook() {
        selectedBook = nil
    }
}

#if DEBUG
extension AIChatViewModel {
    static let preview = AIChatViewModel()
    
    static let mockMessages: [Message] = [
        Message(text: "Hello! How can I help you today?", isUser: false),
        Message(text: "Can you recommend some books?", isUser: true),
        Message(
            text: "Here are some great books I found:",
            isUser: false,
            books: [
                Book.example
            ]
        )
    ]
}
#endif
