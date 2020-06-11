//
//  ContentView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 04.06.20.
//

import SwiftUI
import StatefulTabView

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

    var body: some View {
		VStack(alignment: .center) {
			//Text("Current room")
			//Divider()

			/*
			PageView([
				AnyView(KitchenRootView()),
				AnyView(DiningRootView()),
				AnyView(ProfileView()),
			])
			*/
			/**/
			StatefulTabView(){[
				Tab(title: "INBOX", image: nil) {
					KitchenRootView()
				},
				Tab(title: "Phrases", image: nil) {
					DiningRootView().transition(.slide)
				},
//				Tab(title: "Music", image: nil) {
//					ProfileView()
//				},
//				Tab(title: "Composer", image: nil) {
//					ProfileView()
//				},
				Tab(title: "Profile", image: nil) {
					ProfileView()
				},
			]}
			.barTintColor(.red)
			.barBackgroundColor(.yellow)
			.barAppearanceConfiguration(.opaque)
			/**/
		}
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
			.environmentObject(environment.root)
    }
}
