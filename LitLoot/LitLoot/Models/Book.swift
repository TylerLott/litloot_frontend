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
    let content: String
    
    init(id: UUID = UUID(), title: String, author: String, content: String) {
        self.id = id
        self.title = title
        self.author = author
        self.content = content
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case author
        case content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID() // Generate a new UUID since it's not in the response
        self.title = try container.decode(String.self, forKey: .title)
        self.author = try container.decode(String.self, forKey: .author)
        self.content = try container.decode(String.self, forKey: .content)
    }
}

extension Book {
    static let example = Book(
        title: "Frankenstein; Or, The Modern Prometheus",
        author: "Mary Wollstonecraft Shelley",
        content: "The Project Gutenberg eBook of Frankenstein; Or, The Modern Prometheus. This ebook is for the use of anyone anywhere in the United States and most other parts of the world at no cost and with almost no restrictions whatsoever."
    )
}
