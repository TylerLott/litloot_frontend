//
//  Message.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import Foundation

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let books: [Book]?
    
    init(text: String, isUser: Bool, books: [Book]? = nil) {
        self.text = text
        self.isUser = isUser
        self.books = books
    }
}
