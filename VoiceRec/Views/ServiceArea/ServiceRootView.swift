//
//  ServiceRootView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 18.06.20.
//

import SwiftUI
import StatefulTabView

struct ServiceRootView: View {
    var body: some View {
		StatefulTabView(){[
			Tab(title: "Profile", image: nil) {
				ProfileView()
			},
			Tab(title: "Music", image: nil) {
				MusicBrowserView()
			},
		]}
		.barTintColor(.blue)
		.barAppearanceConfiguration(.opaque)
    }
}

struct ServiceRootView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceRootView()
    }
}
