//
//  KitchenRootView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 05.06.20.
//

import SwiftUI
import StatefulTabView

struct KitchenRootView: View {
    var body: some View {
		StatefulTabView(){[
			Tab(title: "INBOX", image: nil) {
				InboxView()
			},
			Tab(title: "Phrases", image: nil) {
				PhraseBrowserView()
			},
			Tab(title: "Lessons", image: nil) {
				LessonBrowserView()
			},
			Tab(title: "Composer", image: nil) {
				ComposerView()
			},
		]}
		.barTintColor(.blue)
		.barAppearanceConfiguration(.opaque)
    }
}

struct KitchenNavStack_Previews: PreviewProvider {
    static var previews: some View {
        KitchenRootView()
    }
}
