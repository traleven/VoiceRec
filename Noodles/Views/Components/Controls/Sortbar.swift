//
//  Sortbar.swift
//  Noodles
//
//  Created by Ivan on 03/07/2025.
//

import SwiftUI

struct Sortbar: View {
    @Environment(\.style) private var style
    
    var title: String
    var direction: SortOrder = .forward

    var body: some View {
        HStack(alignment: .center) {
            SortPill(title: title, direction: direction)
            Spacer()
            Image(systemName: "line.3.horizontal")
                .resizable()
                .frame(width: 24, height: 24)
        }
        .padding(.leading, 8)
        .padding(.trailing, 16)
        .padding(.top, 8)
        .padding(.bottom, 4)
        .frame(width: 393, alignment: .center)
    }
}

struct SortPill: View {
    @Environment(\.style) private var style
    
    var title: String
    var direction: SortOrder = .forward

    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            Text(title)
                .font(style.font.body.labelSmall)
                .multilineTextAlignment(.center)
                .foregroundStyle(style.color.text.button.secondary)
            
            Image(systemName: direction == .forward ? "arrow.down" : "arrow.up")
                .resizable()
                .frame(width: 10, height: 10)
                .foregroundStyle(style.color.text.button.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .cornerRadius(8)
    }
}

#Preview {
    Sortbar(title: "Recent", direction: .forward)
    Divider()
    Sortbar(title: "Recent", direction: .reverse)
    Divider()
    Sortbar(title: "A-Z")
}
