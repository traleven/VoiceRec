//
//  ColorPalette.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import Foundation
import SwiftUI

extension ColorPalette {
    static let standard = ColorPalette(
        transparent: Color("#FFFFFF", opacity: 0.0),
        white: Color("#FFFFFF"),
        greyLight: Color("#F2F2F2"),
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

struct ColorPalette {
    let transparent: Color
    let white: Color
    let greyLight: Color
    let greyMedium: Color
    let greyDark: Color
    let greyDarkest: Color
    let black: Color
    let blackTransparent: Color
    let brand: Brand
    let utility: Utility
    
    struct Brand {
        let light: Color
        let medium: Color
        let main: Color
        var primary: Color { main }
    }
    
    struct Utility {
        let green: Color
        let amber: Color
        let red: Color
    }
}
