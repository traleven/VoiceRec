//
//  FileListView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 10.06.20.
//

import SwiftUI

struct InboxListView: View {
	@EnvironmentObject var recorder: AudioRecorder
	var name: String?
	var path: URL?
	@State var selection: String?
	@State var selectionIdx: Int?

	var body: some View {
		VStack() {
			List(Egg.fetch(path), id: \.id) {(egg) in
				NavigationLink(destination: InboxListView(name: egg.name, path: egg.file), tag: egg.idx, selection: self.$selectionIdx) {
					InboxEntry(egg: egg)
				}
				.gesture(
					TapGesture().onEnded() {
						self.selection = egg.id
						self.selectionIdx = egg.idx
					}
				)
				.gesture(
					LongPressGesture(minimumDuration: 0.5, maximumDistance: 3).onEnded({ (success: Bool) in
						if success && egg.type == "m4a" {
							AudioPlayer(egg.file)
								.play(
									onProgress: { (_: TimeInterval, _: TimeInterval) in
								}) { (_: Bool) in
							}
						}
						self.selection = egg.id
					})
				)
			}
			.navigationBarTitle(Text(name ?? "INBOX"), displayMode: .inline)
			.navigationBarHidden(path == nil)

			InboxRecorderPanel(path: self.path ?? FileUtils.getDirectory("INBOX"))
		}
    }
}

struct InboxListView_Previews: PreviewProvider {
    static var previews: some View {
		InboxListView(path:FileUtils.getDirectory("INBOX"))
			.environmentObject(AudioRecorder())
			.previewLayout(.fixed(width: 480, height: 800))
    }
}

