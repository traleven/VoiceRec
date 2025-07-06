//
//  PillMenu.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import SwiftUI

struct PillButton<S: StringProtocol>: View {
    @Environment(\.style) private var style

    var action: @MainActor () -> Void
    var label: S
        
    var body: some View {
        Button(action: action, label: {
            
            HStack(alignment: .center, spacing: 6) {
                Text(label)
                    .font(style.font.body.labelSmall)
                    .multilineTextAlignment(.center)
                    .foregroundColor(style.color.text.button.accent)
                
                Image(systemName: "x.circle.fill")
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundColor(style.color.icon.accent.foreground)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(style.color.fill.button.accent)
            .cornerRadius(8)
        })
    }
}

#Preview {
    PillButton(action: {}, label: "Remove")
}
