//
//  FileListView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 10.06.20.
//

import SwiftUI

struct InboxListView: View {
	var name: String?
	var path: URL?
	@State var selectionIdx: Int?
	@State var detailsEgg: Egg?

	var body: some View {
		VStack() {
			List(Egg.fetch(path), id: \.id) {(egg) in
				NavigationLink(destination: InboxListView(name: egg.name, path: egg.file), tag: egg.idx, selection: self.$selectionIdx) {
					InboxEntry(egg: egg)
				}
				.onTapGesture {
					withAnimation { () -> Void in
						self.selectionIdx = egg.idx
					}
				}
				.gesture(
					LongPressGesture(minimumDuration: 0.5, maximumDistance: 3).onEnded({ (success: Bool) in
						if success {
							self.previewItem(egg)
						}
					})
				)
				.popover(item: self.$detailsEgg, content: self.getTextPreview)
			}
			.navigationBarTitle(Text(name ?? "INBOX"), displayMode: .inline)
			.navigationBarHidden(path == nil)

			InboxRecorderPanel(path: self.path ?? FileUtils.getInboxDirectory())
		}
    }

	func previewItem(_ egg: Egg) {
		switch egg.type {
		case "m4a":
			AudioPlayer(egg.file)
				.play(
					onProgress: { (_: TimeInterval, _: TimeInterval) in
				}) { (_: Bool) in
			}
		case "txt", "json":
			detailsEgg = egg
		default:
			do {}
		}
	}

	func getTextPreview(for egg: Egg) -> some View {
		NavigationView() {
			VStack () {
				Text((try? String(contentsOf: egg.file)) ?? "")
				Spacer(minLength: 0)
			}
			.navigationBarTitle(Text("Text note"), displayMode: .inline)
			.navigationBarItems(leading:
				Button(action: {
					self.detailsEgg = nil
				}) {
					Text("Back")
				}
			)
		}
	}
}

struct InboxListView_Previews: PreviewProvider {
    static var previews: some View {
		InboxListView(path:FileUtils.getInboxDirectory())
			.environmentObject(AudioRecorder())
			.previewLayout(.fixed(width: 480, height: 800))
    }
}

