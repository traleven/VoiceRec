//
//  ColorStyle.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import SwiftUI

extension ColorStyle {
    static let standard = ColorStyle(palette: .standard)
    
    init(palette: ColorPalette) {
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
                    disabled: palette.greyDarkest,
                    link: palette.brand.primary
                ),
                placeholder: .init(
                    light: palette.greyDark,
                    medium: palette.greyDarkest
                ),
                button: .init(
                    primary: palette.white,
                    secondary: palette.black,
                    accent: palette.brand.primary
                )
            ),
            line: .init(
                separator: palette.greyMedium,
                divider: palette.greyMedium,
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
                    background: palette.brand.light,
                    invert: palette.white
                ),
                selected: .init(
                    foreground: palette.brand.primary,
                    background: palette.brand.light
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

struct ColorStyle {
    let background: Background
    let fill: Fill
    let text: Text
    let line: Line
    let icon: Icon
    let state: State
    
    struct Background {
        let light, dark, overlay: Color
    }
    
    struct Fill {
        let element: Element
        let button: Button
        
        struct Element {
            let primary, primarySelected, secondary: Color
        }
        struct Button {
            let primary, secondary, accent: Color
        }
    }
    
    struct Text {
        let regular: Regular
        let placeholder: Placeholder
        let button: Button
        
        struct Regular {
            let primary, secondary, selected, disabled, link: Color
        }
        
        struct Placeholder {
            let light, medium: Color
            var dark: Color { medium }
        }
        
        struct Button {
            let primary, secondary, accent: Color
        }
    }
    struct Line {
        let separator, divider, underline: Color
    }
    struct Icon {
        let primary: Primary
        let secondary: Secondary
        let tertiary: Tertiary
        let accent: Accent
        let selected: Selected
        
        struct Primary {
            let foreground: Color
        }
        struct Secondary {
            let foreground, background: Color
        }
        struct Tertiary {
            let foreground, background, outline: Color
        }
        struct Accent {
            let foreground, background, invert: Color
        }
        struct Selected {
            let foreground, background: Color
        }
    }
    struct State {
        let success, error, warning: Color
    }
}
