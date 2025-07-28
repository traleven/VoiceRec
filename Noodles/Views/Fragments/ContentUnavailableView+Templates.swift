//
//  ContentUnavailableView+Templates.swift
//  Noodles
//
//  Created by Ivan on 28/07/2025.
//

import SwiftUI

extension ContentUnavailableView where Actions == EmptyView, Description == Text?, Label == SwiftUI.Label<Text, Image> {
    
    @ViewBuilder
    static func error<S: StringProtocol>(_ description: S) -> some View {
        ContentUnavailableView("Something went terribly wrong", systemImage: "figure.hiking", description: Text(description))
    }
}

#Preview {
    ContentUnavailableView.error("description")
}
