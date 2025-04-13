//
//  AppState.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import Foundation

class AppState: ObservableObject {
    @Published var isInQuiz: Bool = false
    @Published var activeQuizQuestions: [QuizQuestion] = []
}
