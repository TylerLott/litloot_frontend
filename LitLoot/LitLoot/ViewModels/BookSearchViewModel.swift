//
//  BookSearchViewModel.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import Foundation

@MainActor
class BookSearchViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var searchText: String = ""

    private let bookService: BookServiceProtocol

    init(bookService: BookServiceProtocol = BookService()) {
        self.bookService = bookService
        Task {
            await loadBooks()
        }
    }

    func loadBooks() async {
        do {
            books = try await bookService.fetchBooks()
        } catch {
            print("Error loading books: \(error)")
        }
    }

    var filteredBooks: [Book] {
        if searchText.isEmpty {
            return books
        }
        return books.filter {
            $0.title.lowercased().contains(searchText.lowercased()) ||
            $0.author.lowercased().contains(searchText.lowercased())
        }
    }
}
