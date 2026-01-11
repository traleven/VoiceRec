//
//  Multiselectbar.swift
//  Noodles
//
//  Created by Ivan on 03/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

public struct Multiselectbar: View {
    public let style: Style
    public var hasSelected: Bool = false
    
    public init(style: Style, hasSelected: Bool = false) {
        self.style = style
        self.hasSelected = hasSelected
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                Text(hasSelected ? "Unselect all" : "Select all")
                    .font(style.font.body.label)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(style.color.text.button.secondary)
                Spacer()
                Text("Cancel")
                    .font(style.font.body.label)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(style.color.text.button.secondary)
            }
            .padding(0)
            .frame(maxWidth: .infinity, minHeight: 32, maxHeight: 32, alignment: .center)
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
        .padding(.bottom, 12)
    }
}

#Preview {
    Multiselectbar(style: .standard, hasSelected: false)
    Multiselectbar(style: .standard, hasSelected: true)
}
