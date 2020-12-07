//
//  TextPreview.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 16.06.20.
//

import SwiftUI

struct TextPreview: View {
	@Binding var isVisible: Bool
	var egg: Egg
	@State var text: String = ""

    var body: some View {
		NavigationView() {
			VStack () {
				MultilineTextField(text: self.$text)
				Spacer(minLength: 0)
			}
			.onAppear() {
				self.text = (try? String(contentsOf: self.egg.file)) ?? ""
			}
			.navigationBarTitle(Text(egg.name), displayMode: .inline)
			.navigationBarItems(leading:
				Button(action: {
					self.isVisible = false
				}) {
					Text("Back")
				}
			)
			.onDisappear() {
				try! self.text.write(to:self.egg.file, atomically: true, encoding: .utf8)
			}
		}
	}
}

//struct TextPreview_Previews: PreviewProvider {
//    static var previews: some View {
//		TextPreview(isVisible:.constant(true), egg: getEgg(name: "Test", file: FileUtils.getDocumentsDirectory().appendingPathComponent("options.json", isDirectory: false), type: "txt"))
//    }
//}
