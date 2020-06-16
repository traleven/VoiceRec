//
//  InboxRecorderPanel.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 08.06.20.
//

import SwiftUI

struct InboxRecorderPanel: View {
	@EnvironmentObject var recorder: AudioRecorder
	@State var addText: Bool = false
	var path: URL

	var body: some View {
		VStack(alignment: .center) {
			if recorder.isRecording {
				Text("New egg")
				Text(Int(recorder.duration).toTimeString())
			}

			HStack(alignment: .bottom) {
				Button(action: {
					self.addText = true
				}) {
					Image("list_add")
				}
				.popover(isPresented: self.$addText) {
					TextMemoEditor(editing: self.$addText, title: "Text note", placeholder:"Enter your note here...", path: self.path)
				}
					.deleteDisabled(true)
					.disabled(recorder.isRecording)

				Spacer()
				AudioRecorderButton(path: self.path)
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
			InboxRecorderPanel(path: FileUtils.getInboxDirectory())
		}
		.environmentObject(AudioRecorder())
		.previewLayout(.fixed(width: 420, height: 280))
    }
}
