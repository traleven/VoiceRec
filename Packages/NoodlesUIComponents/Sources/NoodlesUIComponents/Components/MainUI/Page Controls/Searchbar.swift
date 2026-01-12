//
//  Searchbar.swift
//  Noodles
//
//  Created by Ivan on 03/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

public struct Searchbar: View {
    public let style: Style

    @Binding public var text: String
    @FocusState private var focus: Element?
    
    private enum Element : Hashable {
        case textField
    }
    
    public init(style: Style, text: Binding<String>) {
        self.style = style
        self._text = text
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 8) {
            HStack(alignment: .center, spacing: 0) {
                Button(action: { withAnimation { focus = .textField }}) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .font(style.font.body.body)
                        .frame(width: 18, height: 18)
                        .foregroundStyle(style.color.text.placeholder.dark)
                        .frame(width: 25, height: 24, alignment: .leading)
                }
                
                TextField("Search", text: $text, prompt: Text("Search")
                    .foregroundStyle(style.color.text.placeholder.dark)
                )
                .focused($focus, equals: .textField)
                .font(style.font.body.body)
                .foregroundColor(style.color.text.regular.primary)
                .frame(maxWidth: .infinity)
                .frame(height: 24)
                
                if focus == .textField || !text.isEmpty {
                    Button(action: {
                        if text.isEmpty {
                            focus = nil
                        }
                        self.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundStyle(style.color.text.placeholder.dark)
                            .frame(width: 24, height: 24, alignment: .center)
                    }
                }
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(style.color.fill.element.primary)
            .cornerRadius(10)
        }
        .frame(height: 40)
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}

#Preview {
    Searchbar(style: .standard, text: .constant("abc"))
    Searchbar(style: .standard, text: .constant(""))
    Searchbar(style: .standard, text: .constant("abc"))
    Searchbar(style: .standard, text: .constant(""))
}
