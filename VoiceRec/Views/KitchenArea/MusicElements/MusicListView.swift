//
//  MusicListView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 22.06.20.
//

import SwiftUI

struct MusicListView: View {
	var name: String?
	var path: URL?
	@State var selectionIdx: Int?
	@Binding var parentSelection: Int?

	var body: some View {
		VStack() {
			List(Broth.fetch(), id: \.id) {(music) in
				ZStack() {
					MusicEntry(music: music)
				}
				.contentShape(Rectangle())
			}
			.navigationBarTitle(Text(name ?? ""), displayMode: .inline)
			.navigationBarHidden(path == nil)
			.navigationBarBackButtonHidden(true)
			.navigationBarItems(leading:
				Button(action: {
					withAnimation { () -> Void in
						self.parentSelection = nil
					}
				}) {
					Text("< Back")
				}
			)
		}
    }
}

struct MusicListView_Previews: PreviewProvider {
    static var previews: some View {
		MusicListView(parentSelection: .constant(nil))
    }
}
