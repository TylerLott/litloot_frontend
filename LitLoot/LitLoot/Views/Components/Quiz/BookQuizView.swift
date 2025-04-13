//
//  BookQuizView.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import SwiftUI

struct BookQuizView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var viewModel: BookQuizViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var animateAnswer = false
    @State private var showExitAlert = false
    @State private var nextButtonBounce = false
    @State private var animatedProgress: Int = 0
    @State private var hasAnswered: Bool = false

    var body: some View {
        VStack {
            if viewModel.quizComplete {
                QuizResultView(score: viewModel.score, totalQuestions: viewModel.totalQuestions) {
                    dismiss()
                }
            } else if viewModel.isLoading {
                ProgressView("Loading question...")
                    .padding()
            } else if let question = viewModel.currentQuestion {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        // Header: Back + Exit
                        HStack {
                            Button(action: {
                                viewModel.goToPreviousQuestion()
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    animatedProgress = max(0, animatedProgress - 1)
                                }
                                hasAnswered = true // Prevent re-increment on revisit
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "chevron.left")
                                    Text("Back")
                                }
                            }
                            .disabled(viewModel.currentIndex == 0)

                            Spacer()

                            Button {
                                showExitAlert = true
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .foregroundColor(.red)
                            }
                            .alert("Exit Quiz?", isPresented: $showExitAlert) {
                                Button("Exit", role: .destructive) {
                                    dismiss()
                                }
                                Button("Cancel", role: .cancel) { }
                            } message: {
                                Text("You won't be able to take the quiz again today.")
                            }
                        }

                        // Always-visible animated progress bar
                        ProgressView(
                            value: Double(animatedProgress),
                            total: Double(viewModel.totalQuestions)
                        )
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .padding(.vertical, 4)
                        .animation(.easeInOut(duration: 0.3), value: animatedProgress)

                        // Question
                        Text(question.question)
                            .font(.title2)
                            .fontWeight(.semibold)

                        // Options
                        ForEach(question.options, id: \.self) { option in
                            Button {
                                if !hasAnswered {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        animatedProgress += 1
                                        hasAnswered = true
                                    }
                                }

                                viewModel.selectAnswer(option)
                                animateAnswerBounce()
                            } label: {
                                Text(option)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.blue.opacity(
                                        viewModel.selectedAnswerForCurrentQuestion() == option ? 0.3 : 0.1
                                    ))
                                    .cornerRadius(10)
                                    .scaleEffect(viewModel.selectedAnswerForCurrentQuestion() == option && animateAnswer ? 1.05 : 1.0)
                                    .animation(.spring(response: 0.4, dampingFraction: 0.5), value: animateAnswer)
                            }
                        }

                        // Next / Finish button
                        let isButtonEnabled = viewModel.selectedAnswerForCurrentQuestion() != nil

                        Button(action: {
                            animateNextButtonBounce()

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                hasAnswered = false
                                if viewModel.currentIndex == viewModel.totalQuestions - 1 {
                                    viewModel.finishQuiz()
                                } else {
                                    viewModel.goToNextQuestion()
                                }
                            }
                        }) {
                            Text(viewModel.currentIndex == viewModel.totalQuestions - 1 ? "Finish Quiz" : "Next")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(isButtonEnabled ? Color.blue : Color.gray)
                                .cornerRadius(10)
                                .scaleEffect(isButtonEnabled && nextButtonBounce ? 1.05 : 1.0)
                                .opacity(isButtonEnabled ? 1.0 : 0.5)
                                .animation(.spring(response: 0.25, dampingFraction: 0.6), value: nextButtonBounce)
                                .transition(.scale.combined(with: .opacity))
                        }
                        .padding(.top, 20)
                        .disabled(!isButtonEnabled)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            }
        }
        .navigationTitle("Book Quiz")
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Animation Helpers

    func animateAnswerBounce() {
        animateAnswer = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            animateAnswer = false
        }
    }

    func animateNextButtonBounce() {
        nextButtonBounce = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            nextButtonBounce = false
        }
    }
}

#Preview {
    NavigationView {
        BookQuizView(viewModel: BookQuizViewModel(book: Book.example))
            .environmentObject(AppState())
    }
}
