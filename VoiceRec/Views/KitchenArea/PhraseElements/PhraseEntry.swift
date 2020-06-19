//
//  PhraseEntry.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 18.06.20.
//

import SwiftUI

struct PhraseEntry: View {
	var phrase: Doughball

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

	func getText(_ phrase: Doughball) -> String {
		return phrase.texts[Settings.language.base]
			?? phrase.texts[Settings.language.target]
			?? phrase.texts.first?.value
			?? "..."
	}

	func getColor(_ phrase: Doughball) -> Color {
		return phrase.texts[Settings.language.base] != nil && phrase.texts[Settings.language.target] != nil ? .green
		: phrase.texts[Settings.language.base] == nil && phrase.texts[Settings.language.target] == nil ? .red
		: .yellow
	}
}

struct PhraseEntry_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			PhraseEntry(phrase: Doughball.make(0, [:]))

			PhraseEntry(phrase: Doughball.make(1, ["English" : "Test"]))

			PhraseEntry(phrase: Doughball.make(2, ["Chinese" : "Test"]))

			PhraseEntry(phrase: Doughball.make(3, ["English" : "Test", "Chinese" : "Test"]))
		}
			.previewLayout(.fixed(width: 320, height: 70))
    }
}

extension PreviewProvider {
}
