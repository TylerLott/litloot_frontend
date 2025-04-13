//
//  UserService.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import Foundation

protocol UserServiceProtocol {
    func fetchProfile() async throws -> UserProfile
}

class UserService: UserServiceProtocol {
    func fetchProfile() async throws -> UserProfile {
        return UserProfile(name: "Tyler Lott", booksRead: 3, goal: 10)
    }
}

