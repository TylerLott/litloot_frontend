//
//  QuizResultView.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import SwiftUI

struct QuizResultView: View {
    let score: Int
    let totalQuestions: Int
    let onFinish: () -> Void

    var passed: Bool {
        Double(score) / Double(totalQuestions) >= 0.8
    }

    @State private var animate = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: passed ? "checkmark.circle.fill" : "xmark.octagon.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(passed ? .green : .red)
                .scaleEffect(animate ? 1.2 : 0.8)
                .opacity(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: animate)

            Text(passed ? "You Passed! 🎉" : "Try Again 😢")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(passed ? .green : .red)

            Text("Score: \(score) out of \(totalQuestions)")
                .font(.title2)

            Spacer()

            Button("Back to Book") {
                onFinish()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(passed ? Color.green : Color.red)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)
        }
        .padding()
        .onAppear { animate = true }
    }
}

#Preview {
    QuizResultView(score: 8, totalQuestions: 10) { }
        .environmentObject(AppState())
}
