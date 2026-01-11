//
//  Inputbar.swift
//  Noodles
//
//  Created by Ivan on 04/07/2025.
//

import SwiftUI
import NoodlesDataModel
import NoodlesPreviewContent
import NoodlesDesignSystem
import NoodlesThemeStandard

public struct Inputbar: View {
    public let style: Style

    @Binding public var text: String
    public var icon: Image?
    public var language: Language
    public var mode: Mode = .standard
    public var onCommit: (String, Language) -> Void
    
    @FocusState private var focus: Field?
    
    private enum Field {
        case textInput
    }
    
    public init(style: Style, text: Binding<String>, icon: Image? = nil, language: Language, mode: Mode = .standard, onCommit: @escaping (String, Language) -> Void) {
        self.style = style
        self._text = text
        self.icon = icon
        self.language = language
        self.mode = mode
        self.onCommit = onCommit
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 8) {
            
            if let icon {
                HStack(alignment: .center, spacing: 8) {
                    icon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 21, height: 21)
                        .foregroundStyle(style.color.icon.tertiary.foreground)
                }
                .padding(5)
                .frame(width: 32, height: 32, alignment: .center)
            }
            
            HStack(alignment: .center, spacing: 4) {
                Text(language.icon)
                    .font(style.font.heading.title3)
                    .multilineTextAlignment(.center)
                    .frame(width: 32, height: 32, alignment: .center)
                
                TextField("New phrase...", text: $text, prompt: Text("New phrase...")
                    .foregroundStyle(style.color.text.placeholder.dark)
                )
                .focused($focus, equals: .textInput)
                .font(style.font.body.body)
                .foregroundColor(style.color.text.regular.primary)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .onSubmit(of: .text) { onCommit(text, language) }
//                .toolbar {
//                    ToolbarItemGroup(placement: .keyboard) {
//                        Inputbar(text: $text, icon: icon, mode: mode)
//                    }
//                }
                
                Image(systemName: text.isEmpty && focus != .textInput ? "microphone.fill" : "arrow.up")
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(text.isEmpty && focus != .textInput ? style.color.icon.tertiary.foreground : style.color.icon.accent.invert)
                    .padding(0)
                    .frame(width: 32, height: 32, alignment: .center)
                    .background(text.isEmpty && focus != .textInput ? style.color.icon.secondary.background : style.color.icon.accent.foreground)
                    .cornerRadius(100)
                    .plainButton(withAnimation: {
                        if focus == .textInput {
                            focus = nil
                        }
                        if !text.isEmpty {
                            onCommit(text, language)
                        }
                    })
            }
            .padding(.leading, 8)
            .padding(.trailing, 4)
            .padding(.vertical, 4)
            .frame(height: 40, alignment: .leading)
            .background(style.color.fill.element.primary)
            .cornerRadius(100)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .cornerRadius(8)
    }
}

extension Inputbar {
    public enum Mode {
        case standard, typing, recording, quickRecording, playing
    }
}

#Preview {
    Inputbar(style: .standard, text: .constant(""), language: Preview.language.en) { print("\($1.id): \($0)") }
    Inputbar(style: .standard, text: .constant("New phrase!"), language: Preview.language.en) { print("\($1.id): \($0)") }
    Inputbar(style: .standard, text: .constant("New phrase!"), icon: Image(systemName: "magnifyingglass"), language: Preview.language.zh) { print("\($1.id): \($0)") }
}
