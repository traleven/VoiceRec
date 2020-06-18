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
	@State var currentPage: Int = 0

    var body: some View {
		VStack(alignment: .center) {
			//Text("Current room")
			//Divider()

			PaginationView(axis: .horizontal, transitionStyle: .pageCurl, showsIndicators: false) {
				[
					AnyView(KitchenRootView()),
					AnyView(DiningRootView()),
					AnyView(ServiceRootView()),
				]
			}
			.cyclesPages(true)
		}
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
			.environmentObject(environment.root)
    }
}
