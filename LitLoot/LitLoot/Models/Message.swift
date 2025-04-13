//
//  Message.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}
