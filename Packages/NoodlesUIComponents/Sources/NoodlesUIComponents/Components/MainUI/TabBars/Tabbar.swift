//
//  Tabbar.swift
//  Noodles
//
//  Created by Ivan on 03/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

public struct Tabbar<SelectionValue: Hashable & CaseIterable & StringRepresentable & IconRepresentable, Content: View>: View {
    public let style: Style

    @Binding public var selection: SelectionValue
    @ViewBuilder public var content: (SelectionValue) -> Content
    
    public init(style: Style, selection: Binding<SelectionValue>, @ViewBuilder content: @escaping (SelectionValue) -> Content) {
        self.style = style
        self._selection = selection
        self.content = content
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            content(selection)
                .frame(maxHeight: .infinity)
            HDivider(style: style)
            HStack(alignment: .center, spacing: 0) {
                ForEach(Array(SelectionValue.allCases), id: \.self) { option in
                    VStack(alignment: .center, spacing: 2) {
                        Image(systemName: option.asIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundStyle(option == selection ? style.color.icon.primary.foreground : style.color.icon.tertiary.foreground, option == selection ? style.color.icon.primary.foreground : style.color.icon.tertiary.foreground)
                        
                        Text(option.asString)
                            .multilineTextAlignment(.center)
                            .font(style.font.body.caption)
                            .foregroundStyle(option == selection ? style.color.text.regular.primary : style.color.text.regular.secondary)
                    }
                    .padding(.top, 12)
                    .plainButton(withAnimation: {
                        selection = option
                    })
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

fileprivate enum TabbarPreviewTabs : CaseIterable, StringRepresentable, IconRepresentable {
    case a, b, c
    var asString: String { "\(self)" }
    var asIcon: String { "person" }
}

#Preview {
//    Tabbar(selection: .constant(0)) {
//        Tab(value: 0, content: {
//            Text("Tzzb")
//        }, label: { TabbarItem(title: "Bzzt", icon: "plus") })
//        Tab(value: 1, content: {
//            Text("Bzzt")
//        }, label: { TabbarItem(title: "Tzzp", icon: "minus") })
//    }
    Tabbar(style: .standard, selection: .constant(TabbarPreviewTabs.a)) { selection in
        Text(verbatim: "\(selection)")
    }
}
