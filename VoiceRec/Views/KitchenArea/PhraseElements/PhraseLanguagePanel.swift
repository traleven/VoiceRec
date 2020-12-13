//
//  PhraseLanguagePanel.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 19.06.20.
//

import SwiftUI
import SwiftUIX

struct PhraseLanguagePanel: View {
	@Binding var text: String
	@Binding var audio: URL?

    var body: some View {
		VStack() {
			CocoaTextField(text: self.$text, label: { Text("") })
				.borderStyle(.roundedRect)
				.multilineTextAlignment(.center)

			AudioPlayerPanel(self.audio)
				.removeIfKeyboardActive()
		}
    }
}

struct PhraseLanguagePanel_Previews: PreviewProvider {
    static var previews: some View {
		PhraseLanguagePanel(text: .constant("Some phrase"), audio: .constant(FileUtils.getDefaultsDirectory(.music).appendingPathComponent("some air.m4a")))
    }
}