//
//  ContentView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 04.06.20.
//

import SwiftUI

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

			PageView([
				AnyView(KitchenRootView()),
				AnyView(DiningRootView()),
				AnyView(ProfileView()),
			])
		}
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
			.environmentObject(environment.root)
    }
}
