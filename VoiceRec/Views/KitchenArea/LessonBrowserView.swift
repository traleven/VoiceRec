//
//  LessonManagerView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 05.06.20.
//

import SwiftUI

struct LessonBrowserView: View {
    var body: some View {
		NavigationView() {
			LessonListView(parentSelection: .constant(nil))
				.border(Color.gray, width: 0.5)
		}
		.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LessonBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        LessonBrowserView()
    }
}
