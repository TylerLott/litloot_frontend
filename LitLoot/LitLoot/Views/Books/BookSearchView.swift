//
//  BookSearchView.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import SwiftUI

struct BookSearchView: View {
    @StateObject private var viewModel = BookSearchViewModel()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search books...", text: $viewModel.searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                List(viewModel.filteredBooks) { book in
                    NavigationLink(destination: BookDetailView(viewModel: BookDetailsViewModel(book: book))) {
                        VStack(alignment: .leading) {
                            Text(book.title).font(.headline)
                            Text(book.author).font(.subheadline).foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Search Books")
        }
    }
}

#Preview {
    BookSearchView()
        .environmentObject(AppState())
}
