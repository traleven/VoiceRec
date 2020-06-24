//
//  LessonEditView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 05.06.20.
//

import SwiftUI
import SwiftUIX

struct LessonEditView: View {
	var lesson: Recipe
	@Binding var parentSelection: Int?

    var body: some View {
		Form() {
			CocoaTextField(text: self.makeNameBinding(self.lesson), label: {
				Text("Lesson name")
			})
				.inputAccessoryView(DoneInputAccessoryView())
				.borderStyle(.roundedRect)
				.multilineTextAlignment(.center)
//			Section(header: Text("\(Settings.language.base)")) {
//				PhraseLanguagePanel(text: makeTextBinding(lesson, language: Settings.language.base), audio: .constant(phrase.baseAudio))
//			}
//			Section(header: Text("\(Settings.language.target)")) {
//				PhraseLanguagePanel(text: makeTextBinding(lesson, language: Settings.language.target), audio: .constant(phrase.targetAudio))
//			}
//			MultilineTextField("Notes", text: makeNotesBinding(phrase))
//				.inputAccessoryView(DoneInputAccessoryView())
		}
		.keyboardAvoiding()
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
				//self.phrase.save()
			}) {
				Text("Save")
			}
		)
    }

	private func makeNameBinding(_ lesson: Recipe) -> Binding<String> {
		return .init(
			get: { return lesson.name },
			set: { lesson.name = $0 }
		)
	}

	private func makeNotesBinding(_ phrase: Phrase) -> Binding<String> {
		return .init(
			get: { return phrase.comment },
			set: { phrase.comment = $0 }
		)
	}
}

struct LessonEditView_Previews: PreviewProvider {
    static var previews: some View {
		LessonEditView(lesson: Recipe.fetch()[0], parentSelection: .constant(nil))
    }
}
