//
//  DiningRootView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 05.06.20.
//

import SwiftUI
import StatefulTabView

struct DiningRootView: View, Identifiable {
	let id: String = "DiningRootView"

	var body: some View {
		StatefulTabView(){
			Tab(title: "Player", image: nil) {
				PlaylistView()
			}
		}
		.barTintColor(.blue)
		.barAppearanceConfiguration(.opaque)
    }
}

struct DiningRootView_Previews: PreviewProvider {
    static var previews: some View {
        DiningRootView()
    }
}
