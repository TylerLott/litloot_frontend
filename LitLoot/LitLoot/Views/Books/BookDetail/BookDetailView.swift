//
//  BookDetailView.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import SwiftUI

struct BookDetailView: View {
    @StateObject var viewModel: BookDetailsViewModel
    @StateObject var quizViewModel: BookQuizViewModel
    @EnvironmentObject var appState: AppState
    @State private var showQuiz = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            BookTitleHeaderView(title: viewModel.book.title, author: viewModel.book.author)
            
            BookDescriptionView(description: viewModel.book.content)
            
            QuizActionButton(quizViewModel: quizViewModel, showQuiz: $showQuiz)
            
            Spacer()
        }
        .padding()
        .navigationTitle(viewModel.book.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showQuiz) {
            NavigationView {
                BookQuizView(viewModel: quizViewModel)
                    .environmentObject(appState)
            }
            .interactiveDismissDisabled()
        }
    }
}

#Preview {
    NavigationView {
        BookDetailView(
            viewModel: BookDetailsViewModel(book: Book.example),
            quizViewModel: BookQuizViewModel(book: Book.example)
        )
        .environmentObject(AppState())
    }
}

