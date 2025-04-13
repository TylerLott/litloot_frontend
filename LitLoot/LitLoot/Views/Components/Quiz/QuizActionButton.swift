//
//  QuizActionButton.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import SwiftUI

struct QuizActionButton: View {
    @ObservedObject var quizViewModel: BookQuizViewModel
    @Binding var showQuiz: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Button(action: {
                Task {
                    await quizViewModel.startQuiz()
                    if !quizViewModel.allQuestions.isEmpty {
                        showQuiz = true
                    }
                }
            }) {
                HStack {
                    if quizViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Take Quiz")
                            .font(.headline)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(quizViewModel.isLoading)
            
            if let error = quizViewModel.error {
                Text(error.localizedDescription)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .alert("Quiz Error", isPresented: $quizViewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(quizViewModel.error?.localizedDescription ?? "An unknown error occurred")
        }
    }
}

#if DEBUG
struct QuizActionButton_Previews: PreviewProvider {
    static var previews: some View {
        QuizActionButton(
            quizViewModel: BookQuizViewModel(book: Book.example),
            showQuiz: .constant(false)
        )
    }
}
#endif
