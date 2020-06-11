//
//  InboxView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 05.06.20.
//

import SwiftUI

struct InboxView: View {
	@ObservedObject var recorder: AudioRecorder = AudioRecorder()
	@State var path: URL = FileUtils.getDirectory("INBOX")
	
    var body: some View {
		ZStack() {
			VStack() {
				KitchenPageHeader(name: "INBOX")
				//Text(FileUtils.getDirectory("INBOX").path)
				//Divider()
				NavigationView() {
					InboxListView()
						.environmentObject(recorder)
						.border(Color.gray, width: 0.5)
				}
			}
//			if recorder.isRecording {
//				Rectangle().opacity(0.5)
//			}
		}
		//Divider()
	}
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
    }
}
