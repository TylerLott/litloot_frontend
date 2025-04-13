//
//  BookDetailView.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import SwiftUI

struct BookDetailView: View {
    @StateObject var viewModel: BookDetailsViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            BookTitleHeaderView(title: viewModel.book.title, author: viewModel.book.author)

            BookDescriptionView(description: viewModel.book.description)

            QuizActionButton(viewModel: viewModel)
                .environmentObject(appState)

            Spacer()
        }
        .padding()
        .navigationTitle(viewModel.book.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadQuiz()
        }
    }
}

#Preview {
    NavigationView {
        BookDetailView(viewModel: BookDetailsViewModel(book: Book.example))
            .environmentObject(AppState())
    }
}

