//
//  BookSearchViewModel.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import Foundation

struct Book: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let author: String
    let description: String
}

extension Book {
    static let example = Book(
        id: UUID(),
        title: "To Kill a Mockingbird",
        author: "Harper Lee",
        description: "A novel about justice, race, and moral growth in the Deep South."
    )
}
