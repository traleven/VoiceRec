//
//  ContentView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 04.06.20.
//

import SwiftUI
import SwiftUIX

struct RootView: View {
	@ObservedObject var viewModel: ViewModel

    var body: some View {
		PaginationView(axis: .horizontal, transitionStyle: .pageCurl, showsIndicators: false) {
			KitchenRootView()
			DiningRootView()
			ServiceRootView()
		}
		.currentPageIndex(self.$viewModel.currentPage)
		.cyclesPages(true)
		.isEdgePanGestureEnabled(true)
		.isPanGestureEnabled(true)
		.isTapGestureEnabled(false)
		.transition(.opacity)
    }
}

extension RootView {
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

extension RootView {
	final class ViewModel: ObservableObject, Defaultable {
		@Published var currentPage: Int = 0
		//@Published var activeRoom: Room = .kitchen

		enum Room: String, CaseIterable, Codable, Hashable {
			case kitchen = "kitchen"
			case diningHall = "diningHall"
			case profile = "profile"
		}

		init() {
		}

		init(currentPage: Int) {
			self.currentPage = currentPage
		}
	}
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
