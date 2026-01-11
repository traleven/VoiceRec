//
//  ColorStyle.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import SwiftUI

extension ColorStyle {
    public init(palette: ColorPalette) {
        self.init(
            background: .init(
                light: palette.white,
                dark: palette.black,
                overlay: palette.blackTransparent
            ),
            fill: .init(
                element: .init(
                    primary: palette.greyLight,
                    primarySelected: palette.brand.light,
                    secondary: palette.greyMedium
                ),
                button: .init(
                    primary: palette.brand.primary,
                    secondary: palette.greyLight,
                    accent: palette.brand.light
                )
            ),
            text: .init(
                regular: .init(
                    primary: palette.black,
                    secondary: palette.greyDarkest,
                    selected: palette.brand.primary,
                    disabled: palette.greyDark,
                    link: palette.brand.primary
                ),
                placeholder: .init(
                    light: palette.greyDark,
                    medium: palette.greyDarkest,
                ),
                button: .init(
                    primary: palette.white,
                    secondary: palette.black,
                    accent: palette.brand.primary
                )
            ),
            line: .init(
                separator: palette.greyMedium,
                divider: palette.greyDark,
                underline: palette.black
            ),
            icon: .init(
                primary: .init(
                    foreground: palette.black
                ),
                secondary: .init(
                    foreground: palette.black,
                    background: palette.greyMedium
                ),
                tertiary: .init(
                    foreground: palette.greyDarkest,
                    background: palette.greyLight,
                    outline: palette.greyDark
                ),
                accent: .init(
                    foreground: palette.brand.primary,
                    background: palette.brand.medium,
                    invert: palette.white
                ),
                selected: .init(
                    foreground: palette.brand.primary,
                    background: palette.brand.light
                ),
                disabled: .init(
                    foreground: palette.greyDark,
                    background: palette.greyLight
                )
            ),
            state: .init(
                success: palette.utility.green,
                error: palette.utility.red,
                warning: palette.utility.amber
            )
        )
    }
}

public struct ColorStyle : Sendable {
    public let background: Background
    public let fill: Fill
    public let text: Text
    public let line: Line
    public let icon: Icon
    public let state: State
    
    public init(background: Background, fill: Fill, text: Text, line: Line, icon: Icon, state: State) {
        self.background = background
        self.fill = fill
        self.text = text
        self.line = line
        self.icon = icon
        self.state = state
    }
    
    public struct Background : Sendable {
        public let light, dark, overlay: Color
        
        public init(light: Color, dark: Color, overlay: Color) {
            self.light = light
            self.dark = dark
            self.overlay = overlay
        }
    }
    
    public struct Fill : Sendable {
        public let element: Element
        public let button: Button
        
        public init(element: Element, button: Button) {
            self.element = element
            self.button = button
        }
        
        public struct Element : Sendable {
            public let primary, primarySelected, secondary: Color
            
            public init(primary: Color, primarySelected: Color, secondary: Color) {
                self.primary = primary
                self.primarySelected = primarySelected
                self.secondary = secondary
            }
        }
        public struct Button : Sendable {
            public let primary, secondary, accent: Color
            
            public init(primary: Color, secondary: Color, accent: Color) {
                self.primary = primary
                self.secondary = secondary
                self.accent = accent
            }
        }
    }
    
    public struct Text : Sendable {
        public let regular: Regular
        public let placeholder: Placeholder
        public let button: Button
        
        public init(regular: Regular, placeholder: Placeholder, button: Button) {
            self.regular = regular
            self.placeholder = placeholder
            self.button = button
        }
        
        public struct Regular : Sendable {
            public let primary, secondary, selected, disabled, link: Color
            
            public init(primary: Color, secondary: Color, selected: Color, disabled: Color, link: Color) {
                self.primary = primary
                self.secondary = secondary
                self.selected = selected
                self.disabled = disabled
                self.link = link
            }
        }
        
        public struct Placeholder : Sendable {
            public let light, medium: Color
            public var dark: Color { medium }
            
            public init(light: Color, medium: Color) {
                self.light = light
                self.medium = medium
            }
        }
        
        public struct Button : Sendable {
            public let primary, secondary, accent: Color
            
            public init(primary: Color, secondary: Color, accent: Color) {
                self.primary = primary
                self.secondary = secondary
                self.accent = accent
            }
        }
    }
    
    public struct Line : Sendable {
        public let separator, divider, underline: Color
        
        public init(separator: Color, divider: Color, underline: Color) {
            self.separator = separator
            self.divider = divider
            self.underline = underline
        }
    }
    
    public struct Icon : Sendable {
        public let primary: Primary
        public let secondary: Secondary
        public let tertiary: Tertiary
        public let accent: Accent
        public let selected: Selected
        public let disabled: Disabled
        
        public init(primary: Primary, secondary: Secondary, tertiary: Tertiary, accent: Accent, selected: Selected, disabled: Disabled) {
            self.primary = primary
            self.secondary = secondary
            self.tertiary = tertiary
            self.accent = accent
            self.selected = selected
            self.disabled = disabled
        }
        
        public struct Primary : Sendable {
            public let foreground: Color
            
            public init(foreground: Color) {
                self.foreground = foreground
            }
        }
        public struct Secondary : Sendable {
            public let foreground, background: Color
            
            public init(foreground: Color, background: Color) {
                self.foreground = foreground
                self.background = background
            }
        }
        public struct Tertiary : Sendable {
            public let foreground, background, outline: Color
            
            public init(foreground: Color, background: Color, outline: Color) {
                self.foreground = foreground
                self.background = background
                self.outline = outline
            }
        }
        public struct Accent : Sendable {
            public let foreground, background, invert: Color
            
            public init(foreground: Color, background: Color, invert: Color) {
                self.foreground = foreground
                self.background = background
                self.invert = invert
            }
        }
        public struct Selected : Sendable {
            public let foreground, background: Color
            
            public init(foreground: Color, background: Color) {
                self.foreground = foreground
                self.background = background
            }
        }
        public struct Disabled : Sendable {
            public let foreground, background: Color
            
            public init(foreground: Color, background: Color) {
                self.foreground = foreground
                self.background = background
            }
        }
    }
    
    public struct State : Sendable {
        public let success, error, warning: Color
        
        public init(success: Color, error: Color, warning: Color) {
            self.success = success
            self.error = error
            self.warning = warning
        }
    }
}
