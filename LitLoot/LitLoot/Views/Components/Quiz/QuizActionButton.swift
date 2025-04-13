//
//  QuizActionButton.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import SwiftUI

struct QuizActionButton: View {
    @ObservedObject var viewModel: BookDetailsViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if viewModel.isLoading {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 50)

                    ProgressView()
                }
            } else {
                Button(action: {
                    Task {
                        await viewModel.loadQuiz()
                        appState.activeQuizQuestions = viewModel.quizQuestions
                        appState.isInQuiz = true
                    }
                }) {
                    Text("Take Quiz")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
        .padding(.top)
    }
}
