//
//  AIChatView.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import SwiftUI

struct AIChatView: View {
    @StateObject private var viewModel = AIChatViewModel()

    var body: some View {
        VStack {
            ChatScrollView(messages: viewModel.messages, isTyping: viewModel.isTyping, animatingMessageID: viewModel.animatingMessageID)

            Divider()

            ChatInputBar(
                inputText: $viewModel.inputText,
                isInputEmpty: viewModel.inputText.isEmpty,
                onSend: viewModel.sendMessage
            )
        }
        .navigationTitle("AI Chat")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Chat ScrollView

struct ChatScrollView: View {
    let messages: [ChatMessage]
    let isTyping: Bool
    let animatingMessageID: UUID?

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(messages) { message in
                        ChatBubble(message: message, isAnimating: message.id == animatingMessageID)
                            .id(message.id)
                    }

                    if isTyping {
                        HStack {
                            LoadingDots()
                                .frame(height: 20)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(.systemGray5))
                                .cornerRadius(12)
                            Spacer()
                        }
                        .transition(.opacity)
                        .animation(.easeInOut, value: isTyping)
                    }
                }
                .padding()
            }
            .onChange(of: messages.count) {
                if let last = messages.last {
                    withAnimation {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
        }
    }
}

// MARK: - Chat Bubble

struct ChatBubble: View {
    let message: ChatMessage
    let isAnimating: Bool
    @State private var animatedText: String = ""

    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.text)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            } else {
                Text(isAnimating ? animatedText : message.text)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                    .onAppear {
                        if isAnimating {
                            animateTyping()
                        }
                    }
                Spacer()
            }
        }
    }

    private func animateTyping() {
        animatedText = ""
        let characters = Array(message.text)
        var delay: Double = 0.0

        for char in characters {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                animatedText.append(char)
            }

            // Adjust delay based on character
            switch char {
            case ".", "!", "?":
                delay += 0.35
            case ",", ";", ":":
                delay += 0.2
            case " ":
                delay += 0.1
            default:
                delay += 0.035
            }
        }
    }
}

// MARK: - Chat Input Bar

struct ChatInputBar: View {
    @Binding var inputText: String
    let isInputEmpty: Bool
    let onSend: () -> Void

    var body: some View {
        HStack {
            TextField("Ask something...", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(minHeight: 44)

            Button(action: onSend) {
                Image(systemName: "paperplane.fill")
                    .font(.title2)
                    .foregroundColor(isInputEmpty ? .gray : .blue)
            }
            .disabled(isInputEmpty)
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}

// MARK: - Loading Dots Animation

struct LoadingDots: View {
    @State private var animate = false

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 6, height: 6)
                    .scaleEffect(animate ? 1.2 : 0.6)
                    .animation(
                        Animation
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: animate
                    )
            }
        }
        .foregroundColor(.gray)
        .onAppear {
            animate = true
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        AIChatView()
    }
}
