//
//  MainTabView.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showBookSearch = false
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(0)

                Text("Explore")
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Explore")
                    }
                    .tag(1)
                
                BookSearchView()
                    .tag(2)

                AIChatView()
                    .padding(.bottom, 32)
                    .tabItem {
                        Image(systemName: "ellipsis.bubble.fill")
                        Text("Chat")
                    }
                    .tag(3)

                Text("Profile")
                    .tabItem {
                        Image(systemName: "person.circle")
                        Text("Profile")
                    }
                    .tag(4)
            }

            // Floating "+" Button
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        selectedTab = 2
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 60, height: 60)
                                .shadow(radius: 5)
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 28, weight: .bold))
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
        }
        .fullScreenCover(isPresented: $appState.isInQuiz) {
            NavigationView {
                BookQuizView(viewModel: BookQuizViewModel(quizService: QuizService()))
            }
            .environmentObject(appState)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
}
