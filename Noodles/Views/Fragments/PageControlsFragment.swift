//
//  PageControlsFragment.swift
//  Noodles
//
//  Created by Ivan on 04/07/2025.
//

import SwiftUI
import NoodlesUIComponents

struct PageControlsFragment: View {
    @Environment(\.style) private var style
    
    @Binding var searchText: String
    var mode: Mode = .standard
    
    var body: some View {
        VStack {
            Searchbar(style: style, text: $searchText)
            if mode == .standard {
                Filterbar(style: style)
            }
            if mode == .multiselect {
                Multiselectbar(style: style)
            }
            Divider()
            if mode == .standard {
                Sortbar(style: style, title: "Recent")
            }
        }
    }
}

extension PageControlsFragment {
    enum Mode {
        case standard, multiselect
    }
}

#Preview {
    VStack {
        PageControlsFragment(searchText: .constant("abc"))
            .background(Color.white)
        PageControlsFragment(searchText: .constant("abc"), mode: .multiselect)
            .background(Color.white)
    }
    .padding(.vertical)
    .background(Color.green)
}
