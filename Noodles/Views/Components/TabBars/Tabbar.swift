//
//  Tabbar.swift
//  Noodles
//
//  Created by Ivan on 03/07/2025.
//

import SwiftUI

struct Tabbar<SelectionValue: Hashable & CaseIterable & StringRepresentable & IconRepresentable, Content: View>: View {
    @Environment(\.style) private var style

    @Binding var selection: SelectionValue
    @ViewBuilder var content: (SelectionValue) -> Content
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            content(selection)
                .frame(maxHeight: .infinity)
            HDivider()
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
    Tabbar(selection: .constant(TabbarPreviewTabs.a)) { selection in
        Text(verbatim: "\(selection)")
    }
}
