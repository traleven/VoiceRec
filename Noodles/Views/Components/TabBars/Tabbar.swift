//
//  Tabbar.swift
//  Noodles
//
//  Created by Ivan on 03/07/2025.
//

import SwiftUI

struct Tabbar<SelectionValue: Hashable, Content: TabContent>: View {
    @Environment(\.style) private var style

    @Binding var selection: SelectionValue
    @TabContentBuilder<SelectionValue> var content: () -> Content
    
    var body: some View {
        SwiftUI.TabView(selection: $selection, content: content)
            .tint(style.color.text.regular.primary)
    }
}

#Preview {
    Tabbar(selection: .constant(0)) {
        Tab(value: 0, content: {
            Text("Tzzb")
        }, label: { TabbarItem(title: "Bzzt", icon: "plus") })
        Tab(value: 1, content: {
            Text("Bzzt")
        }, label: { TabbarItem(title: "Tzzp", icon: "minus") })
    }
}
