//
//  InboxRecorderPanel.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 08.06.20.
//

import SwiftUI

struct InboxRecorderPanel: View {
	@EnvironmentObject var recorder: AudioRecorder

	var body: some View {
		VStack(alignment: .center) {
			if recorder.isRecording {
				Text("New egg")
				Text(Int(recorder.duration).toTimeString())
			}

			HStack(alignment: .bottom) {
				Button(action: {
				}) {
					Image("list_add")
				}
					.deleteDisabled(true)
					.disabled(recorder.isRecording)

				Spacer()
				AudioRecorderButton()
				Spacer()

				Button(action: {
				}) {
					Image("lesson_add_to")
				}
					.deleteDisabled(true)
					.disabled(recorder.isRecording)
			}
		}.padding()
    }
}

struct InboxRecorderPanel_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			InboxRecorderPanel()
				.environmentObject(AudioRecorder())
				.previewLayout(.fixed(width: 420, height: 280))
		}
    }
}
