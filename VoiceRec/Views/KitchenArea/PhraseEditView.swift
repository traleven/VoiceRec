//
//  PhraseEditView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 05.06.20.
//

import SwiftUI
import SwiftUIX

struct PhraseEditView: View {
	var phrase: Phrase
	@Binding var parentSelection: UUID?

    var body: some View {
		Form() {
			Section(header: Text("\(Settings.language.base)")) {
				PhraseLanguagePanel(text: makeTextBinding(phrase, language: Settings.language.base), audio: .constant(phrase.baseAudio))
			}
			Section(header: Text("\(Settings.language.target)")) {
				PhraseLanguagePanel(text: makeTextBinding(phrase, language: Settings.language.target), audio: .constant(phrase.targetAudio))
			}
			MultilineTextField("Notes", text: makeNotesBinding(phrase))
				.inputAccessoryView(DoneInputAccessoryView())
		}
		.keyboardType(.default)
		.navigationBarTitle("", displayMode: .inline)
		.navigationBarHidden(false)
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading:
			Button(action: {
				withAnimation { () -> Void in
					self.parentSelection = nil
				}
			}) {
				Text("< Back")
			},
			trailing: Button(action: {
				self.phrase.save()
			}) {
				Text("Save")
			}
		)
    }

	private func makeTextBinding(_ phrase: Phrase, language: String) -> Binding<String> {
		return .init(
			get: { return phrase.texts[language] ?? "" },
			set: { phrase.texts[language] = $0 }
		)
	}

	private func makeNotesBinding(_ phrase: Phrase) -> Binding<String> {
		return .init(
			get: { return phrase.comment },
			set: { phrase.comment = $0 }
		)
	}
}

struct PhraseEditView_Previews: PreviewProvider {
    static var previews: some View {
		PhraseEditView(phrase: Phrase.make(0, ["English" : "Test", "Chinese" : "Test"]), parentSelection: .constant(UUID()))
    }
}
