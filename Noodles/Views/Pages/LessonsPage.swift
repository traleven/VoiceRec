//
//  LessonsPage.swift
//  Noodles
//
//  Created by Ivan on 04/07/2025.
//

import SwiftUI
import NoodlesUIComponents

struct LessonsPage: View {
    @State var searchText: String = ""

    var body: some View {
        PageLayout(toolbar: {
            Navbar(mode: .regular)
        }, controls: {
            PageControlsFragment(searchText: $searchText, mode: .standard)
        }, content: {
            List {}
        })
    }
}

#Preview {
    LessonsPage()
}
