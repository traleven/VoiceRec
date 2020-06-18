//
//  InboxView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 05.06.20.
//

import SwiftUI

struct InboxView: View {
	var recorder: AudioRecorder = AudioRecorder()
	@State var path: URL = FileUtils.getInboxDirectory()
	
    var body: some View {
		ZStack() {
			VStack() {
				KitchenPageHeader(name: "INBOX")

				NavigationView() {
					InboxListView(parentSelection: .constant(nil))
						.environmentObject(recorder)
						.border(Color.gray, width: 0.5)
				}
				.navigationViewStyle(StackNavigationViewStyle())
			}
		}
	}
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
    }
}
