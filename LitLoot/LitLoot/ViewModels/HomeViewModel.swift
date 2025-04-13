//
//  HomeViewModel.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var featuredBooks: [Book] = [Book.example]
    @Published var userProfile: UserProfile = UserProfile.example

    // Eventually can inject BookService, ProfileService, etc.

    func incrementBooksRead() {
        userProfile.booksRead += 1
    }

    func updateGoal(to newGoal: Int) {
        userProfile.goal = newGoal
    }
}
