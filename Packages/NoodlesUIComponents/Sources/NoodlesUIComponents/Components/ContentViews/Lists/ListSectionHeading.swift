//
//  ListSectionHeading.swift
//  Noodles
//
//  Created by Ivan on 06/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

struct ListSectionHeading<Title: StringProtocol>: View {
    let style: Style

    var title: Title
    var icon: Image? = nil
    var size: Size = .large
    var isExpanded: Expanded? = nil
    
    var fontColor: Color {
        switch size {
        case .large: return style.color.text.regular.primary
        case .small: return style.color.text.regular.secondary
        }
    }
    
    var fontStyle: FontStyle.Style {
        switch size {
        case .large: return style.font.heading.title3
        case .small: return style.font.heading.title4
        }
    }
    
    var iconSize: CGFloat {
        switch size {
        case .large: return 24
        case .small: return 20
        }
    }
    
    var chevronSize: CGFloat {
        switch size {
        case .large: return 24
        case .small: return 10
        }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Text(title)
                .font(fontStyle)
                .foregroundColor(fontColor)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            if let icon {
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(style.color.icon.tertiary.foreground)
                    .frame(width: iconSize, height: iconSize)
            }
            
            if let isExpanded {
                Image(systemName: isExpanded.rawValue ? "chevron.up" : "chevron.down")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(style.color.icon.tertiary.foreground)
                    .frame(width: chevronSize, height: chevronSize)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(alignment: .leading)
    }
}

extension ListSectionHeading {
    enum Size {
        case small, large
    }
    
    enum Expanded: RawRepresentable {
        case open, closed
        
        var rawValue: Bool {
            switch self {
            case .open: return true
            case .closed: return false
            }
        }
        
        init?(rawValue: Bool) {
            self = rawValue ? .open : .closed
        }
    }
}

#Preview {
    ListSectionHeading(style: .standard, title: "Section heading")
    ListSectionHeading(style: .standard, title: "Section heading", icon: Image(systemName: "square"))
    ListSectionHeading(style: .standard, title: "Section heading", isExpanded: .open)
    ListSectionHeading(style: .standard, title: "Section heading", isExpanded: .closed)
    ListSectionHeading(style: .standard, title: "Section heading", icon: Image(systemName: "square"), isExpanded: .closed)
    Divider()
    ListSectionHeading(style: .standard, title: "Section heading", size: .small)
    ListSectionHeading(style: .standard, title: "Section heading", icon: Image(systemName: "square"), size: .small)
    ListSectionHeading(style: .standard, title: "Section heading", size: .small, isExpanded: .open)
    ListSectionHeading(style: .standard, title: "Section heading", size: .small, isExpanded: .closed)
    ListSectionHeading(style: .standard, title: "Section heading", icon: Image(systemName: "square"), size: .small, isExpanded: .closed)
}
