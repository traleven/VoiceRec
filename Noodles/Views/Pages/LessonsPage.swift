//
//  LessonsPage.swift
//  Noodles
//
//  Created by Ivan on 04/07/2025.
//

import SwiftUI
import NoodlesUIComponents

struct LessonsPage: View {
    @Environment(\.style) private var style
    @State var searchText: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // controls
            PageControlsFragment(searchText: $searchText, mode: .standard)
            
            // content
            List {}
        }.toolbar {
            Navbar(style: style, mode: .regular)
        }
    }
}

#Preview {
    LessonsPage()
}
