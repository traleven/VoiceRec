//
//  TabbarItem.swift
//  Noodles
//
//  Created by Ivan on 03/07/2025.
//

import SwiftUI

struct TabbarItem<Title: StringProtocol>: View {
    @Environment(\.style) private var style
    @Environment(\.isFocused) private var isFocused

    var title: Title
    var icon: Image
    
    var body: some View {
        icon
            .foregroundStyle(isFocused
                 ? style.color.icon.primary.foreground
                 : style.color.icon.tertiary.foreground
            )
            .frame(width: 24, height: 24)
        
        Text(title)
            .font(isFocused
                ? style.font.body.captionBold
                : style.font.body.caption
            )
            .foregroundStyle(isFocused
                ? style.color.text.regular.primary
                : style.color.text.regular.secondary
            )
    }
}

extension TabbarItem {
    init(title: Title, icon: String) {
        self.init(title: title, icon: Image(systemName: icon))
    }
}

#Preview {
    SwiftUI.TabView {
        Tab(content: {
            Text("Tzzb")
        }, label: {
            TabbarItem(title: "Hello", icon: "plus")
        })
        Tab(content: {
            Text("Tzzb")
        }, label: {
            TabbarItem(title: "Goodbye", icon: "minus")
        })
    }
    .tint(.black)
}
