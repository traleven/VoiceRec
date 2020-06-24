//
//  PhraseEntry.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 18.06.20.
//

import SwiftUI

struct PhraseEntry: View {
	var phrase: Phrase

	var body: some View {
		HStack() {
			Image("check_unselected")
				.colorInvert()
				.colorMultiply(self.getColor(self.phrase))
				.scaleEffect(0.7)

			VStack() {
				if self.phrase.baseText != nil {
					Text(self.phrase.baseText!)
						.font(.headline)
				}
				if self.phrase.targetText != nil {
					Text(self.phrase.targetText!)
						.font(.subheadline)
				}
			}
			Spacer(minLength: 0)
		}
    }

	func getColor(_ phrase: Phrase) -> Color {
		return phrase.texts[Settings.language.base] != nil && phrase.texts[Settings.language.target] != nil ? .green
		: phrase.texts[Settings.language.base] == nil && phrase.texts[Settings.language.target] == nil ? .red
		: .yellow
	}
}

struct PhraseEntry_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			ForEach(Phrase.fetch(FileUtils.getDefaultsDirectory(.phrases))) {
				PhraseEntry(phrase: $0)
			}
		}
		.previewLayout(.fixed(width: 320, height: 70))
    }
}
