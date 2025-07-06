//
//  SecondaryButton.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import SwiftUI

struct SecondaryButton<S: StringProtocol>: View {
    @Environment(\.style) private var style
    @Environment(\.isEnabled) private var isEnabled
    
    let action: @MainActor () -> Void
    var label: S
    var icon: Image
    var role: Role = .regular
    
    private var iconColor: Color {
        guard isEnabled else { return style.color.text.regular.disabled }
        switch role {
        case .regular: return style.color.icon.primary.foreground
        case .prominent: return style.color.text.button.accent
        case .whatsApp: return style.color.text.button.primary
        }
    }
    private var labelColor: Color {
        guard isEnabled else { return style.color.text.regular.disabled }
        switch role {
        case .regular: return style.color.text.button.secondary
        case .prominent: return style.color.text.button.accent
        case .whatsApp: return style.color.text.button.primary
        }
    }
    private var backgroundColor: Color {
        guard isEnabled else { return style.color.fill.button.secondary }
        switch role {
        case .regular: return style.color.fill.button.secondary
        case .prominent: return style.color.fill.button.accent
        case .whatsApp: return style.color.state.success
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 4) {
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16.25, height: 16.25)
                    .foregroundStyle(iconColor)
                    .padding(2)
                    .frame(width: 20, height: 20, alignment: .center)
                
                Text(label)
                    .font(style.font.body.labelSmall)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(labelColor)
            }
            .padding(.leading, 8)
            .padding(.trailing, 12)
            .padding(.vertical, 6)
            .background(backgroundColor)
            .cornerRadius(100)
        }
    }
}

extension SecondaryButton {
    enum Role {
        case regular, prominent, whatsApp
    }
}

extension SecondaryButton {
    init(action: @escaping @MainActor () -> Void, label: S, icon: String, role: Role = .regular) {
        self.init(action: action, label: label, icon: Image(systemName: icon), role: role)
    }
}

#Preview {
    SecondaryButton(
        action: {},
        label: "Default",
        icon: Image(systemName: "plus.circle.fill")
    )
    
    SecondaryButton(
        action: {},
        label: "Disabled",
        icon: Image(systemName: "minus.circle.fill")
    ).disabled(true)
    
    SecondaryButton(
        action: {},
        label: "Prominent",
        icon: Image(systemName: "plus.circle.fill"),
        role: .prominent
    )
    
    SecondaryButton(
        action: {},
        label: "WhatsApp",
        icon: Image(systemName: "bubble"),
        role: .whatsApp
    )
}
