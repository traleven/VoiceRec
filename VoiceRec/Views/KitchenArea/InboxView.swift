//
//  InboxView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 05.06.20.
//

import SwiftUI

struct InboxView: View {
	var recorder: AudioRecorder = AudioRecorder()
	@State var path: URL = FileUtils.getDirectory(.inbox)
	
    var body: some View {
		NavigationView() {
			InboxListView(name: "Inbox", path: FileUtils.getDirectory(.inbox), parentSelection: .constant(nil))
				.environmentObject(recorder)
				.border(Color.gray, width: 0.5)
				.navigationBarItems(leading:
					Button(action: {
					}) {
						Image(systemName: "line.horizontal.3")
							.font(.title)
					}
					.foregroundColor(.black)
				)
		}
		.navigationViewStyle(StackNavigationViewStyle())
	}
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
    }
}
