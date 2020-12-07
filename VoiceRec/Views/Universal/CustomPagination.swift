//
//  CustomPagination.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 26.06.20.
//

import SwiftUI

struct CustomPagination: View {
	@State var currentPage: Int = 0
	var pages: [AnyView]

    var body: some View {
		self.pages[self.currentPage].gesture(TapGesture())
    }
}

struct CustomPagination_Previews: PreviewProvider {
    static var previews: some View {
        CustomPagination(pages: [AnyView(Text("Page 1"))])
    }
}
