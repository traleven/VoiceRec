//
//  LessonEntry.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 22.06.20.
//

import SwiftUI

struct LessonEntry: View {
	var lesson: Model.Recipe

	var body: some View {
		HStack() {
			Image("check_unselected")
				.scaleEffect(0.7)

			VStack() {
				Text(self.lesson.name)
					.font(.headline)
			}
			Spacer(minLength: 0)
		}
    }
}

struct LessonEntry_Previews: PreviewProvider {
    static var previews: some View {
		let fridge = Model.Fridge<Model.Recipe>(FileUtils.getDefaultsDirectory(.lessons))
		let items = fridge.fetch()
		Group {
			LessonEntry(lesson: items[0])
			LessonEntry(lesson: items[1])
		}
		.previewLayout(.fixed(width: 320, height: 70))

    }
}
