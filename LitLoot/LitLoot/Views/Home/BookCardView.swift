//
//  BookCardView.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import SwiftUI

struct BookCardView: View {
    let book: Book

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 60)
                    .overlay(
                        Image(systemName: "book.closed")
                            .font(.title)
                            .foregroundColor(.white)
                    )

                BookInfoView(title: book.title, author: book.author)

                Spacer()

                DetailsButton(book: book)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct BookInfoView: View {
    let title: String
    let author: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .lineLimit(1)

            Text("by \(author)")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)

            Spacer()
        }
    }
}

import SwiftUI

struct DetailsButton: View {
    let book: Book

    var body: some View {
        NavigationLink(
            destination: BookDetailView(
                viewModel: BookDetailsViewModel(book: book)
            )
            .environmentObject(AppState())
        ) {
            Text("Details")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(12)
                .frame(minHeight: 44)
        }
        .alignmentGuide(.top) { d in d[.top] }
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 16) {
            BookCardView(book: Book.example)
        }
    }
    .padding()
}

