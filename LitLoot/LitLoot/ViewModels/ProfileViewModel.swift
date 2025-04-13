//
//  ProfileViewModel.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile?

    private let userService: UserServiceProtocol

    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
        Task { await loadProfile() }
    }

    func loadProfile() async {
        do {
            profile = try await userService.fetchProfile()
        } catch {
            print("Failed to load profile: \(error)")
        }
    }
}

