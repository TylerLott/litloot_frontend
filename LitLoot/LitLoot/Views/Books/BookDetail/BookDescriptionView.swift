//
//  BookDescriptionView.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import SwiftUI

struct BookDescriptionView: View {
    let description: String

    var body: some View {
        Text(description)
            .font(.body)
    }
}
