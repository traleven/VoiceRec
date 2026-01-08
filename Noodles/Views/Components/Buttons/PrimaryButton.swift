//
//  PrimaryButton.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import SwiftUI
import NoodlesDesignSystem

struct PrimaryButton<S: StringProtocol>: View {
    @Environment(\.style) private var style
    @Environment(\.isEnabled) private var isEnabled
    
    let action: @MainActor () -> Void
    let label: S

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(style.font.body.labelLarge)
                .foregroundStyle(style.color.text.button.primary)
                .padding(.horizontal, 0)
                .padding(.vertical, 12)
                .frame(width: 361, alignment: .center)
                .background(style.color.fill.button.primary.opacity(isEnabled ? 1.0 : 0.5))
                .cornerRadius(16)
        }
    }
}

#Preview {
    PrimaryButton(action: {}, label: "Done")
    PrimaryButton(action: {}, label: "Done").disabled(true)
}
