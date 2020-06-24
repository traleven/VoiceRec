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
			VStack() {
				Section() {
					Image("profile_new")
						.clipShape(Circle())
						.scaledToFill()
					Text("Ivan Dolgushin")
						.font(.title)
						.foregroundColor(.blue)
					Text("idipster@gmail.com")
						.font(.footnote)
						.underline()
				}
				MusicListView(parentSelection: .constant(nil))
					.border(Color.gray, width: 0.5)
			}
		}
		.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MusicBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        MusicBrowserView()
    }
}
