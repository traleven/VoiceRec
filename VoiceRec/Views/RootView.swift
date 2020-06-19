//
//  ContentView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 04.06.20.
//

import SwiftUI
import SwiftUIX

final class RootEnvironment: ObservableObject {
	@Published var activeRoom: Room = .kitchen

	enum Room: String, CaseIterable, Codable, Hashable {
		case kitchen = "kitchen"
		case diningHall = "diningHall"
		case profile = "profile"
	}
}

struct RootView: View {
	@EnvironmentObject var environment: RootEnvironment
	@State var currentPage: Int = 3
	@State var preloaded: Bool = false

    var body: some View {
		VStack(alignment: .center) {
			PaginationView(axis: .horizontal, transitionStyle: .pageCurl, showsIndicators: false) {
				self.pages
			}
			.currentPageIndex(self.$currentPage)
			.cyclesPages(true)
			.isTapGestureEnabled(false)
			// HACK: Loading sequence hack to fix the bug
			// with invalid initial layout of the subview
			.onAppear {
				if !self.preloaded {
					self.currentPage = 0
					DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
						self.preloaded = true
					})
				}
			}
		}
    }

	var pages: [AnyView] {
		get {
			// HACK: Loading sequence hack to fix the bug
			// with invalid initial layout of the subview
			preloaded
			? [
				AnyView(LazyView() { KitchenRootView() }),
				AnyView(LazyView() { DiningRootView() }),
				AnyView(LazyView() { ServiceRootView() }),
			]
			: [
				AnyView(LazyView() { KitchenRootView() }),
				AnyView(LazyView() { DiningRootView() }),
				AnyView(LazyView() { ServiceRootView() }),
				AnyView(LoadingView()),
			]
		}
	}
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
			.environmentObject(environment.root)
    }
}
