//
//  EmptyPage.swift
//  Noodles
//
//  Created by Ivan on 06/07/2025.
//

import SwiftUI
import NoodlesUIComponents

struct EmptyPage<Title: StringProtocol>: View {
    @Environment(\.style) private var style
    
    var title: Title
    var icon: String = "plus.circle"
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            EmptyPageButton(style: style, title: title, icon: icon)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    EmptyPage(title: "Button label")
}
