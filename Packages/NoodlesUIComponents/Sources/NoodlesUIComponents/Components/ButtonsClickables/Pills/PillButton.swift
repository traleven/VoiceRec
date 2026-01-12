//
//  PillMenu.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

struct PillButton<S: StringProtocol>: View {
    let style: Style

    var action: @MainActor () -> Void
    var label: S
    var icon: Image? = nil
    var role: Role = .accent
    
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
        Button(action: action, label: {
            
            HStack(alignment: .center, spacing: 6) {
                Text(label)
                    .font(style.font.body.labelSmall)
                    .multilineTextAlignment(.center)
                    .foregroundColor(labelColor)
                
                if let icon {
                    icon
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(iconColor)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(backgroundColor)
            .cornerRadius(8)
        })
    }
}

extension PillButton {
    enum Role {
        case regular, accent, noOutline
    }
}

#Preview {
    PillButton(style: .standard, action: {}, label: "Remove", icon: Image(systemName: "x.circle.fill"))
    PillButton(style: .standard, action: {}, label: "Remove")
    Divider()
    PillButton(style: .standard, action: {}, label: "Remove", icon: Image(systemName: "x.circle.fill"), role: .regular)
    PillButton(style: .standard, action: {}, label: "Remove", role: .regular)
    Divider()
    PillButton(style: .standard, action: {}, label: "Remove", icon: Image(systemName: "x.circle.fill"), role: .noOutline)
    PillButton(style: .standard, action: {}, label: "Remove", role: .noOutline)
}
