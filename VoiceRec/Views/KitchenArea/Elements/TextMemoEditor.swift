//
//  TextMemoEditor.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 12.06.20.
//

import SwiftUI
import SwiftUIX

struct TextMemoEditor: View {
	@State var text: String = ""
	@Binding var editing: Bool
	var title: String
	var placeholder: String
	var path: URL

    var body: some View {
		NavigationView() {
			VStack() {
				MultilineTextField(placeholder, text: $text)
				.onDisappear() {
					if !self.text.isEmpty {
						let dir = FileUtils.convertToDirectory(self.path)
						let file = FileUtils.getNewInboxFile(at: dir, withExtension: "txt")
						try! self.text.write(to:file, atomically: true, encoding: .utf8)
					}
					self.editing = false
				}
				Spacer(minLength: 0)
			}
			.keyboardAvoiding()
			.navigationBarTitle(Text(title), displayMode: .inline)
			.navigationBarItems(trailing: Button(action: {
				self.editing = false
			}) {
				Text("Save")
			})
		}
    }
}

struct TextMemoEditor_Previews: PreviewProvider {
    static var previews: some View {
		TextMemoEditor(editing:.constant(true), title: "Test", placeholder: "Enter you note here...", path: FileUtils.getDirectory(.inbox).appendingPathComponent("test.txt"))
    }
}
