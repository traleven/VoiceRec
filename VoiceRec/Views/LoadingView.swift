//
//  LoadingView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 18.06.20.
//

import SwiftUI
import SwiftUIX

struct LoadingView: View {
	@State var isLoaded: Bool = false

    var body: some View {
		if isLoaded {
			return AnyView(KitchenRootView())
		}

		return AnyView(
			EmptyView()
			.onAppear() {
				withAnimation() {
					self.isLoaded = true
				}
			}
		)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
