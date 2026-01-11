//
//  ColorPalette.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import Foundation
import SwiftUI
import NoodlesDesignSystem

extension ColorPalette {
    public static let standard = ColorPalette(
        transparent: Color("#FFFFFF", opacity: 0.0),
        white: Color("#FFFFFF"),
        greyLight: Color("#F3F4F6"),
        greyMedium: Color("#EAEAEA"),
        greyDark: Color("#CCCCCC"),
        greyDarkest: Color("#7B7B7B"),
        black: Color("#0E0E0E"),
        blackTransparent: Color("#0E0E0E", opacity: 0.5),
        brand: Brand(
            light: Color("#EFF5FD"),
            medium: Color("#CCE1FF"),
            main: Color("#2962E9")
        ),
        utility: Utility(
            green: Color("#0DD061"),
            amber: Color("#FFA807"),
            red: Color("#ED4956")
        )
    )
}
