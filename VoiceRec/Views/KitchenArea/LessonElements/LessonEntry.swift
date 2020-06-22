//
//  LessonEntry.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 22.06.20.
//

import SwiftUI

struct LessonEntry: View {
	var lesson: Recipe

	var body: some View {
		HStack() {
			Image("check_unselected")
				.scaleEffect(0.7)

			VStack() {
				Text(self.lesson.name!)
					.font(.headline)
			}
			Spacer(minLength: 0)
		}
    }
}

struct LessonEntry_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			LessonEntry(lesson: Recipe.fetch()[0])
			LessonEntry(lesson: Recipe.fetch()[1])
		}
			.previewLayout(.fixed(width: 320, height: 70))

    }
}
