//
//  WelcomeHeaderView.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import SwiftUI

struct WelcomeHeaderView: View {
    let name: String

    var body: some View {
        Text("Welcome, \(name)")
            .font(.title)
    }
}
