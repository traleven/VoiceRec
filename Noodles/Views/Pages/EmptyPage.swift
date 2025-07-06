//
//  EmptyPage.swift
//  Noodles
//
//  Created by Ivan on 06/07/2025.
//

import SwiftUI

struct EmptyPage<Title: StringProtocol>: View {
    var title: Title
    var icon: String = "plus.circle"
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            EmptyPageButton(title: title, icon: icon)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    EmptyPage(title: "Button label")
}
