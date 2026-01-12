//
//  PillMenu.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

struct PillMenu<S: StringProtocol, Content: View>: View {
    let style: Style

    @ViewBuilder var content: () -> Content
    var label: S
    var role: Role = .regular
    
    private var iconColor: Color {
        switch role {
        case .regular: return style.color.text.button.secondary
        case .accent: return style.color.text.button.accent
        case .noOutline: return style.color.text.button.secondary
        }
    }
    private var labelColor: Color {
        switch role {
        case .regular: return style.color.text.button.secondary
        case .accent: return style.color.text.button.accent
        case .noOutline: return style.color.text.button.secondary
        }
    }
    private var backgroundColor: Color {
        switch role {
        case .regular: return style.color.fill.button.secondary
        case .accent: return style.color.fill.button.accent
        case .noOutline: return style.palette.transparent
        }
    }
    
    var body: some View {
        Menu(content: content, label: {
            
            HStack(alignment: .center, spacing: 6) {
                Text(label)
                    .font(style.font.body.labelSmall)
                    .multilineTextAlignment(.center)
                    .foregroundColor(labelColor)
                
                Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .foregroundColor(iconColor)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(backgroundColor)
            .cornerRadius(8)
        })
    }
}

extension PillMenu {
    enum Role {
        case regular, accent, noOutline
    }
}

#Preview {
    PillMenu(style: .standard, content: { Button("Option") {} }, label: "Regular")
    PillMenu(style: .standard, content: { Button("Option") {} }, label: "Accent", role: .accent)
    PillMenu(style: .standard, content: { Button("Option") {} }, label: "No Outline", role: .noOutline)
}
