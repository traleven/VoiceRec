//
//  KitchenRootView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 05.06.20.
//

import SwiftUI
import StatefulTabView

struct KitchenRootView: View {
	@ObservedObject var viewModel : ViewModel

    var body: some View {
		StatefulTabView(selectedIndex: self.$viewModel.tabIndex){
			Tab(title: "INBOX", systemImageName: "tray.and.arrow.down") {
				InboxView()
			}
			Tab(title: "My Noodles", systemImageName: "folder") {
				SlidingTabView(selection: self.$viewModel.slidingIndex, tabs: ["Phrases", "Lessons"])
					.removeIfKeyboardActive()
				if self.viewModel.slidingIndex == 0 {
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
		.hideTabBarIfKeyboardActive()
		.navigationBarTitle(Text(""), displayMode: .inline)
		.navigationBarHidden(true)
	}
}

extension KitchenRootView {
	final class ViewModel: ObservableObject, Defaultable {
		@Published var tabIndex : Int = 0
		@Published var slidingIndex : Int = 0

		init() {}

		init(tabIndex: Int, slidingIndex: Int) {
			self.tabIndex = tabIndex
			self.slidingIndex = slidingIndex
		}
	}
}

extension KitchenRootView {
	init() {
		if let viewModel : ViewModel = ViewModelRegistry.fetch() {
			self.viewModel = viewModel
		} else {
			self.viewModel = ViewModel()
			ViewModelRegistry.register(self.viewModel)
		}
	}

	init(_ model: ViewModel) {
		self.viewModel = model
	}
}

struct KitchenNavStack_Previews: PreviewProvider {
    static var previews: some View {
        KitchenRootView()
    }
}
