//
//  FileListView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 10.06.20.
//

import SwiftUI

struct InboxListView: View {
	var name: String
	var path: URL
	@State var selectionIdx: URL?
	@State var addText: Bool = false
	@Binding var parentSelection: URL?

	var body: some View {
		VStack() {
			List(Egg.fetch(path), id: \.id) {(egg) in
				InboxEntry(egg: egg, selection: self.$selectionIdx)
					.navigate(isActive: self.makeActivationBinding(egg.id)) {
						InboxListView(name: egg.name, path: egg.file, parentSelection: self.$selectionIdx)
					}
			}
			.overlay(self.addTextButton, alignment: .bottomTrailing)
			.navigationBarTitle(Text(name), displayMode: .inline)
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

			InboxRecorderPanel(path: self.path)
		}
    }

	func makeActivationBinding(_ id: URL) -> Binding<Bool> {
		return .init(
			get: {
				return self.selectionIdx == id
			},
			set: {
				self.selectionIdx = $0 ? id : nil
			}
		)
	}

	var addTextButton: some View {
		get {
			Button(
				action:{
					withAnimation { () -> Void in
						self.addText.toggle()
					}
				}
			) {
				Image(systemName: "plus.circle.fill")
					.font(.largeTitle)
					.padding()
			}
			.sheet(isPresented: self.$addText) {
				TextMemoEditor(
					editing: self.$addText,
					title: "Text note",
					placeholder:"Enter your note here...",
					path: self.path
				)
			}

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
		InboxListView(name: "Inbox", path:FileUtils.getDefaultsDirectory(.inbox), parentSelection: .constant(nil))
			.environmentObject(AudioRecorder())
			.previewLayout(.fixed(width: 480, height: 800))
    }
}
