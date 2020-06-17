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

    var body: some View {
		NavigationView() {
			VStack () {
				Text((try? String(contentsOf: egg.file)) ?? "")
				Spacer(minLength: 0)
			}
			.navigationBarTitle(Text("Text note"), displayMode: .inline)
			.navigationBarItems(leading:
				Button(action: {
					self.isVisible = false
					//self.presentationMode.wrappedValue.dismiss()
				}) {
					Text("Back")
				}
			)
		}    }
}

struct TextPreview_Previews: PreviewProvider {
    static var previews: some View {
		TextPreview(isVisible:.constant(true), egg: getEgg(name: "Test", file: FileUtils.getDocumentsDirectory().appendingPathComponent("options.json", isDirectory: false), type: "txt"))
    }
}
