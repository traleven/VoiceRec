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
		ZStack {
			if (self.isLoaded) {
				RootView().transition(.opacity)
			}
			if (!self.isLoaded) {
				Image("compose_normal").transition(.opacity)
			}
		}
		.onAppear() {
			if (!self.isLoaded) {
				withAnimation(Animation.default.delay(1)) {
					self.isLoaded.toggle()
				}
			}
		}
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
