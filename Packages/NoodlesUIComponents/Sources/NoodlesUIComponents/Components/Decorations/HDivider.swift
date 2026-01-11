//
//  HDivider.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

struct HDivider: View {
    let style: Style

    var body: some View {
        style.color.line.divider.frame(height: 1)
    }
}

#Preview {
    HDivider(style: .standard)
}
