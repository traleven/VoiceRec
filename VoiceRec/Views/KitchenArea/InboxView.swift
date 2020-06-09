//
//  InboxView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 05.06.20.
//

import SwiftUI

struct InboxView: View {
	@ObservedObject var recorder: AudioRecorder = AudioRecorder()
	
    var body: some View {
		NavigationView() {
			VStack() {
				ZStack() {
					VStack() {
						KitchenPageHeader(name: "INBOX")
						Divider()
						List(Egg.fetch(), id: \.id) {(egg) in
							NavigationLink(destination: PhraseEditView()) {
								InboxEntry(egg: egg)
							}
						}
					}
					if recorder.isRecording {
						Rectangle().opacity(0.5)
					}
				}

				Divider()
				
				InboxRecorderPanel()
					.environmentObject(recorder)
			}
			.navigationBarTitle(Text(""), displayMode: .inline)
			.navigationBarHidden(true)
		}
	}
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
    }
}
