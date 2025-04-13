//
//  AIChatViewModel.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import Foundation
import Combine

@MainActor
class AIChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isTyping: Bool = false
    @Published var animatingMessageID: UUID? = nil

    func sendMessage() {
        let userMessage = ChatMessage(text: inputText, isUser: true)
        messages.append(userMessage)
        inputText = ""

        isTyping = true

        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay

            let responseText = await mockAIResponse(for: userMessage.text)
            let response = ChatMessage(text: responseText, isUser: false)

            await MainActor.run {
                self.isTyping = false
                self.messages.append(response)
                self.animatingMessageID = response.id

                // Clear animating flag after typing animation completes
                let animationDuration = Double(responseText.count) * 0.03
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration + 0.3) {
                    self.animatingMessageID = nil
                }
            }
        }
    }

    private func mockAIResponse(for input: String) async -> String {
        // Simulate a real response
        return "Here's a thoughtful reply to: \"\(input)\""
    }
}

