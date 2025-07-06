//
//  PageLayout.swift
//  Noodles
//
//  Created by Ivan on 04/07/2025.
//

import SwiftUI

struct PageLayout<Toolbar: ToolbarContent, Controls: View, Content: View, Input: View>: View {
    @ToolbarContentBuilder var toolbar: () -> Toolbar
    @ViewBuilder var controls: () -> Controls
    @ViewBuilder var content: () -> Content
    @ViewBuilder var input: () -> Input
    
    var body: some View {
        VStack {
            controls()
            content()
            input()
        }.toolbar(content: toolbar)
    }
}

extension PageLayout where Input == EmptyView {
    init(@ToolbarContentBuilder toolbar: @escaping () -> Toolbar, @ViewBuilder controls: @escaping () -> Controls, @ViewBuilder content: @escaping () -> Content) {
        self.init(toolbar: toolbar, controls: controls, content: content, input: { EmptyView() })
    }
}

#Preview {
    PageLayout(toolbar: {
        ToolbarItem(content: { Text("toolbar") })
    }, controls: {
        Text("Controls")
    }, content: {
        Text("Content")
    }, input: {
        Text("Input")
    })
}
