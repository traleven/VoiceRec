//
//  View+FontStyle.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import SwiftUI
import NoodlesDesignSystem

extension View {
    @ViewBuilder func font(_ style: FontStyle.Style) -> some View {
        self
            .font(style.font)
            .kerning(style.letterSpacing)
            .lineSpacing(style.lineSpacing)
    }
}
