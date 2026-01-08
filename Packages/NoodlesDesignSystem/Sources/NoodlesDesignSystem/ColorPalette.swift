//
//  ColorPalette.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import Foundation
import SwiftUI

public struct ColorPalette : Sendable {
    public let transparent: Color
    public let white: Color
    public let greyLight: Color
    public let greyMedium: Color
    public let greyDark: Color
    public let greyDarkest: Color
    public let black: Color
    public let blackTransparent: Color
    public let brand: Brand
    public let utility: Utility
    
    public init(transparent: Color, white: Color, greyLight: Color, greyMedium: Color, greyDark: Color, greyDarkest: Color, black: Color, blackTransparent: Color, brand: Brand, utility: Utility) {
        self.transparent = transparent
        self.white = white
        self.greyLight = greyLight
        self.greyMedium = greyMedium
        self.greyDark = greyDark
        self.greyDarkest = greyDarkest
        self.black = black
        self.blackTransparent = blackTransparent
        self.brand = brand
        self.utility = utility
    }
    
    public struct Brand : Sendable {
        public let light: Color
        public let medium: Color
        public let main: Color
        public var primary: Color { main }
        
        public init(light: Color, medium: Color, main: Color) {
            self.light = light
            self.medium = medium
            self.main = main
        }
    }
    
    public struct Utility : Sendable {
        public let green: Color
        public let amber: Color
        public let red: Color
        
        public init(green: Color, amber: Color, red: Color) {
            self.green = green
            self.amber = amber
            self.red = red
        }
    }
}
