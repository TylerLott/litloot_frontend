//
//  HomeView.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    WelcomeHeaderView(name: viewModel.userProfile.name)

                    BookProgressView(
                        booksRead: viewModel.userProfile.booksRead,
                        goal: viewModel.userProfile.goal
                    )

                    Divider()

                    Text("Featured Books")
                        .font(.headline)
                    ForEach(viewModel.featuredBooks) { book in
                        BookCardView(book: book)
                    }
                }
                .padding()
            }
            .navigationTitle("LitLoot")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Handle favorites
                    }) {
                        Image(systemName: "heart")
                    }
                    Button(action: {
                        // Handle messages
                    }) {
                        Image(systemName: "paperplane")
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
