//
//  HSeparator.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

struct VSeparator: View {
    let style: Style

    var body: some View {
        style.color.line.separator.frame(width: 1)
    }
}

#Preview {
    VSeparator(style: .standard)
}
