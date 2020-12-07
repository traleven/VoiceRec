//
//  KitchenRootView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 05.06.20.
//

import SwiftUI
import StatefulTabView

struct KitchenRootView: View {
	@State var tabIndex = 0
	@State var slidingIdx = 0

    var body: some View {
		StatefulTabView(selectedIndex: $tabIndex){
			Tab(title: "INBOX", systemImageName: "tray.and.arrow.down") {
				InboxView()
			}
			Tab(title: "My Noodles", systemImageName: "folder") {
				SlidingTabView(selection: self.$slidingIdx, tabs: ["Phrases", "Lessons"])
				if self.slidingIdx == 0 {
					PhraseBrowserView()
				} else {
					LessonBrowserView()
				}
			}
//			Tab(title: "Composer", systemImageName: "headphones") {
//				ComposerView()
//			},
		}
		.barTintColor(.blue)
		.barAppearanceConfiguration(.transparent)
		.navigationBarTitle(Text(""), displayMode: .inline)
		.navigationBarHidden(true)
	}
}

struct KitchenNavStack_Previews: PreviewProvider {
    static var previews: some View {
        KitchenRootView()
    }
}
