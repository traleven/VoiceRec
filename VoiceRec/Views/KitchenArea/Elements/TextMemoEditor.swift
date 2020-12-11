//
//  TextMemoEditor.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 12.06.20.
//

import SwiftUI
import SwiftUIX

struct TextMemoEditor: View {
	@ObservedObject var viewModel: ViewModel

    var body: some View {
		NavigationView() {
			VStack() {
				TextEditor(text: self.$viewModel.text)
				Spacer(minLength: 0)
			}
			.navigationBarTitle(Text(self.viewModel.title), displayMode: .inline)
			.navigationBarItems(trailing: Button(action: {
				self.viewModel.editing = false
			}) {
				Text("Save")
			})
			.onDisappear() {
				if !self.viewModel.text.isEmpty {
					self.viewModel.save()
				}
				self.viewModel.editing = false
			}
		}
    }
}

extension TextMemoEditor {
	final class ViewModel: ObservableObject {
		var text: String = ""

		var title: String
		var placeholder: String
		var parent: InboxListView.ViewModel
		var path: URL {
			get { parent.egg.id }
		}
		var editing: Bool {
			get { parent.addText }
			set { parent.addText = newValue }
		}

		init(parent: InboxListView.ViewModel, title: String, placeholder: String) {
			self.parent = parent
			self.title = title
			self.placeholder = placeholder
		}

		func save() {
			let dir = FileUtils.convertToDirectory(self.path)
			let file = FileUtils.getNewInboxFile(at: dir, withExtension: "txt")
			try! self.text.write(to:file, atomically: true, encoding: .utf8)

			parent.path = dir
			parent.refresh()
		}
	}
}

extension TextMemoEditor {
	init(parent: InboxListView.ViewModel, title: String, placeholder: String) {
		self.viewModel = ViewModel(parent: parent, title: title, placeholder: placeholder)
	}

	init(_ model: ViewModel) {
		self.viewModel = model
	}
}

struct TextMemoEditor_Previews: PreviewProvider {
    static var previews: some View {
		TextMemoEditor(parent: InboxListView.ViewModel(path: FileUtils.getDirectory(.inbox)), title: "Test title", placeholder: "Write something here...")
    }
}
