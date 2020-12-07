//
//  ContentView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 04.06.20.
//

import SwiftUI
import SwiftUIX

struct RootView: View {
	@EnvironmentObject var environment: ViewModel
	@State var currentPage: Int = 0//3
	@State var preloaded: Bool = false

    var body: some View {
		//VStack(alignment: .center) {
			PaginationView(axis: .horizontal, transitionStyle: .pageCurl, showsIndicators: false) {
				KitchenRootView()
				DiningRootView()
				ServiceRootView()
			}
			.currentPageIndex(self.$currentPage)
			.cyclesPages(true)
			.isEdgePanGestureEnabled(true)
			.isPanGestureEnabled(true)
			.isTapGestureEnabled(false)
			// HACK: Loading sequence hack to fix the bug
			// with invalid initial layout of the subview
//			.onAppear {
//				if !self.preloaded {
//					self.currentPage = 0
//					DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
//						self.preloaded = true
//					})
//				}
//			}
		//}
    }
}

extension RootView {
	final class ViewModel: ObservableObject {
		@Published var activeRoom: Room = .kitchen

		enum Room: String, CaseIterable, Codable, Hashable {
			case kitchen = "kitchen"
			case diningHall = "diningHall"
			case profile = "profile"
		}
	}
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
			.environmentObject(RootView.ViewModel())
    }
}
