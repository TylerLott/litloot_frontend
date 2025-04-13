//
//  UserProfile.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import Foundation

struct UserProfile: Codable, Equatable {
    var name: String
    var booksRead: Int
    var goal: Int
}

extension UserProfile {
    var progress: Double {
        goal == 0 ? 0 : Double(booksRead) / Double(goal)
    }

    static let example = UserProfile(name: "Tyler Lott", booksRead: 3, goal: 10)
}
