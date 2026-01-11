//
//  HSeparator.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

public struct HSeparator: View {
    public let style: Style
    
    public init(style: Style) {
        self.style = style
    }

    public var body: some View {
        style.color.line.separator.frame(height: 1)
    }
}

#Preview {
    HSeparator(style: .standard)
}
