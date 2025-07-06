//
//  PhrasesPage.swift
//  Noodles
//
//  Created by Ivan on 04/07/2025.
//

import SwiftUI

struct PhrasesPage: View {
    @State var searchText: String = ""
    @State var inputText: String = ""
    
    var body: some View {
        PageLayout(toolbar: {
            Navbar(mode: .regular)
        }, controls: {
            PageControlsFragment(searchText: $searchText, mode: .standard)
        }, content: {
            List {}
        }, input: {
            Inputbar(text: $inputText)
        })
    }
}

#Preview {
    PhrasesPage()
}
