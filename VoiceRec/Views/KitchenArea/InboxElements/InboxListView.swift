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
	@Binding var parentSelection: Int?

	var body: some View {
		VStack() {
			List(Egg.fetch(path), id: \.id) {(egg) in
				ZStack() {
					NavigationLink(destination: InboxListView(name: egg.name, path: egg.file, parentSelection: self.$selectionIdx), tag: egg.idx, selection: self.$selectionIdx) {
						EmptyView()
					}
					.allowsHitTesting(false)
					InboxEntry(egg: egg)
				}
				.contentShape(Rectangle())
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
				.popover(item: self.$detailsEgg, content:
					{_ in
						TextPreview(isVisible: self.makeBinding(egg), egg: egg)
					}
				)
			}
			.navigationBarTitle(Text(name ?? "INBOX"), displayMode: .inline)
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

			InboxRecorderPanel(path: self.path ?? FileUtils.getDirectory(.inbox))
		}
    }

	func makeBinding(_ egg: Egg) -> Binding<Bool> {
		.init(
			get: { () -> Bool in
				self.detailsEgg == egg
			},
			set: { (v: Bool) in
				self.detailsEgg = nil
			}
		)
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
}

extension InboxListView {
	class ViewModel: ObservableObject {
		var id = UUID()
		var selectionIdx: Int? = nil {
            willSet {
				objectWillChange.send()
			}
        }
		var detailsEgg: Egg? = nil {
			willSet {
				if newValue != detailsEgg {
					objectWillChange.send()
				}
			}
		}
	}
}

struct InboxListView_Previews: PreviewProvider {
    static var previews: some View {
		InboxListView(path:FileUtils.getDefaultsDirectory(.inbox), parentSelection: .constant(nil))
			.environmentObject(AudioRecorder())
			.previewLayout(.fixed(width: 480, height: 800))
    }
}
