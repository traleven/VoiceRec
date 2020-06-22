//
//  MusicBrowserView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 18.06.20.
//

import SwiftUI

struct MusicBrowserView: View {
    var body: some View {
		NavigationView() {
			MusicListView(parentSelection: .constant(nil))
				.border(Color.gray, width: 0.5)
		}
		.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MusicBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        MusicBrowserView()
    }
}
