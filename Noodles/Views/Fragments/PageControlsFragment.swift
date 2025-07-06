//
//  PageControlsFragment.swift
//  Noodles
//
//  Created by Ivan on 04/07/2025.
//

import SwiftUI

struct PageControlsFragment: View {
    @Binding var searchText: String
    var mode: Mode = .standard
    
    var body: some View {
        VStack {
            Searchbar(text: $searchText)
            if mode == .standard {
                Filterbar()
            }
            if mode == .multiselect {
                Multiselectbar()
            }
            Divider()
            if mode == .standard {
                Sortbar(title: "Recent")
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
