//
//  PhraseEntry.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 18.06.20.
//

import SwiftUI

struct PhraseEntry: View {
	var phrase: Model.Phrase

	var body: some View {
		HStack() {
			Image("check_unselected")
				.colorInvert()
				.colorMultiply(self.getColor(self.phrase))
				.scaleEffect(0.7)

			VStack() {
				if self.phrase.baseText != "" {
					Text(self.phrase.baseText)
						.font(.headline)
				}
				if self.phrase.targetText != "" {
					Text(self.phrase.targetText)
						.font(.subheadline)
				}
			}
			Spacer(minLength: 0)
		}
    }

	func getColor(_ phrase: Model.Phrase) -> Color {
		return phrase.baseText != "" && phrase.targetText != "" ? .green
		: phrase.baseText == "" && phrase.targetText == "" ? .red
		: .yellow
	}
}


struct PhraseEntry_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			let fridge = Model.Fridge<Model.Phrase>(FileUtils.getDefaultsDirectory(.phrases))
			ForEach(fridge.fetch()) {
				PhraseEntry(phrase: $0)
			}
		}
		.previewLayout(.fixed(width: 320, height: 70))
    }
}
