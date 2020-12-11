//
//  TextPreview.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 16.06.20.
//

import SwiftUI

struct TextPreview: View {
	@ObservedObject var viewModel: ViewModel

    var body: some View {
		NavigationView() {
			VStack () {
				TextEditor(text: self.$viewModel.text)
				Spacer(minLength: 0)
			}
			.navigationBarTitle(Text(viewModel.egg.name), displayMode: .inline)
			.navigationBarItems(leading:
				Button(action: {
					flush()
					self.viewModel.showDetails = false
				}) {
					Text("Back")
				}
			)
			.onDisappear() {
				flush()
			}
		}
	}

	private func flush() {
		try! self.viewModel.text.write(to:self.viewModel.egg.id, atomically: true, encoding: .utf8)
		self.viewModel.egg = Model.Egg(id: self.viewModel.egg.id)
	}
}

extension TextPreview {
	class ViewModel: ObservableObject {
		var parent: InboxEntry.ViewModel
		@Published var text: String

		var egg: Model.Egg {
			get { parent.egg }
			set { parent.egg = newValue }
		}
		var showDetails: Bool {
			get { parent.showDetails }
			set { parent.showDetails = newValue }
		}

		init(parent: InboxEntry.ViewModel) {
			self.parent = parent
			self.text = (try? String(contentsOf: parent.egg.id)) ?? ""
		}
	}
}

extension TextPreview {
	init(viewModel: InboxEntry.ViewModel) {
		self.viewModel = ViewModel(parent: viewModel)
	}
}

//struct TextPreview_Previews: PreviewProvider {
//    static var previews: some View {
//		TextPreview(isVisible:.constant(true), egg: getEgg(name: "Test", file: FileUtils.getDocumentsDirectory().appendingPathComponent("options.json", isDirectory: false), type: "txt"))
//    }
//}
