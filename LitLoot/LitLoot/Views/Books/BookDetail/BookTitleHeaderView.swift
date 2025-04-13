//
//  BookTitleHeaderView.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import SwiftUI

struct BookTitleHeaderView: View {
    let title: String
    let author: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("by \(author)")
                .font(.title2)
                .foregroundColor(.secondary)
        }
    }
}
