//
//  FontList.swift
//  Noodles
//
//  Created by Ivan on 03/07/2025.
//

import SwiftUI

struct FontList: View {
    var body: some View {
        List {
            ForEach(UIFont.familyNames.sorted(), id: \.self) { family in
                Section(family) {
                    ForEach(UIFont.fontNames(forFamilyName: family).sorted(), id: \.self) { name in
                        Text(name)
                    }
                }
            }
        }
    }
}

#Preview {
    FontList()
}
