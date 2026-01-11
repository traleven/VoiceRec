//
//  TextInput.swift
//  Noodles
//
//  Created by Ivan on 07/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

struct TextInput<S: StringProtocol>: View {
    let style: Style

    var prompt: S
    @Binding var text: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            TextField(prompt, text: $text, prompt: Text(prompt)
                .foregroundStyle(style.color.text.placeholder.light)
            )
            .labelsHidden()
            .font(style.font.body.body)
            .foregroundStyle(style.color.text.regular.primary)
            .frame(maxWidth: .infinity, minHeight: 24, maxHeight: 24, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    TextInput(style: .standard, prompt: "Input", text: .constant(""))
    TextInput(style: .standard, prompt: "Input", text: .constant("Abc"))
}
