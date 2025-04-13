//
//  BookProgressView.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import SwiftUI

struct BookProgressView: View {
    let booksRead: Int
    let goal: Int

    private var progress: Double {
        guard goal > 0 else { return 0 }
        return min(Double(booksRead) / Double(goal), 1.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "fork.knife")
                    .font(.title)
                    .foregroundColor(.orange)

                Text("Reading Reward")
                    .font(.headline)
            }

            ProgressView(value: progress)
                .accentColor(.green)
                .scaleEffect(x: 1, y: 3, anchor: .center)
                .clipShape(Capsule())
                .animation(.easeInOut, value: progress)

            Text("\(booksRead) of \(goal) books read")
                .font(.subheadline)
                .foregroundColor(.secondary)

            if booksRead >= goal {
                HStack(spacing: 10) {
                    Text("🎉 Pizza Unlocked!")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.purple)

                    Image(systemName: "gift.fill")
                        .foregroundColor(.purple)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}

#Preview {
    BookProgressView(booksRead: 3, goal: 10)
}
