//
//  LessonListView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 22.06.20.
//

import SwiftUI

struct LessonListView: View {
	var name: String?
	var path: URL?
	@State var selectionIdx: Int?
	@Binding var parentSelection: Int?

	var body: some View {
		VStack() {
			List(Recipe.fetchDefault(), id: \.id) {(lesson) in
				ZStack() {
					NavigationLink(destination: LessonEditView(lesson: lesson, parentSelection: self.$selectionIdx), tag: lesson.idx, selection: self.$selectionIdx) {
						EmptyView()
					}
					LessonEntry(lesson: lesson)
				}
				.contentShape(Rectangle())
			}
			.navigationBarTitle(Text(name ?? ""), displayMode: .inline)
			.navigationBarHidden(path == nil)
			.navigationBarBackButtonHidden(true)
			.navigationBarItems(leading:
				Button(action: {
					withAnimation { () -> Void in
						self.parentSelection = nil
					}
				}) {
					Text("< Back")
				}
			)
		}
    }
}

struct LessonListView_Previews: PreviewProvider {
    static var previews: some View {
		LessonListView(parentSelection: .constant(nil))
    }
}
