//
//  InboxEntry.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 08.06.20.
//

import SwiftUI

struct InboxEntry: View {
	var egg: Egg

    var body: some View {
		HStack() {
			if (egg.type == "m4a") {

				Image("speech")
					.scaleEffect(0.5)
				Text(egg.name)
					.multilineTextAlignment(.leading)
					.padding()

			} else if (egg.type == "txt" || egg.type == "json") {

				Image("reorder")
					.scaleEffect(0.5)
				Text(egg.name)
					.multilineTextAlignment(.leading)
					.padding()

			} else if (egg.type == "") {

				Image("folder_selected")
					.scaleEffect(0.5)
				Text(egg.name)
					.multilineTextAlignment(.leading)
					.padding()

			} else {
				Text(egg.name)
					.multilineTextAlignment(.leading)
					.padding()
			}
			Spacer()
		}
    }

	@GestureState var isLongPress = false // will be true till tap hold

	var plusLongPress: some Gesture {
		LongPressGesture(minimumDuration: 1).sequenced(before:
			  DragGesture(minimumDistance: 0, coordinateSpace:
			  .local)).updating($isLongPress) { value, state, transaction in
				switch value {
					case .second(true, nil):
						state = true
					   // side effect here if needed
					default:
						break
				}
			}
	}
}

struct InboxEntry_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			InboxEntry(egg: getEgg(name: "Test audio egg", file: Bundle.main.url(forResource: "some air", withExtension: "m4a"), type: "m4a"))

			InboxEntry(egg: getEgg(name: "Test text egg", file: Bundle.main.resourceURL, type: "txt"))

			InboxEntry(egg: getEgg(name: "Test package", file: FileUtils.getDirectory(.inbox), type: ""))
		}
			.previewLayout(.fixed(width: 320, height: 70))
    }
}

extension PreviewProvider {
	static func getEgg(name: String, file: URL?, type: String) -> Egg {
		let egg = Egg()
		egg.name = Egg.getName(for: file!, of: type)
		egg.file = file
		egg.type = type
		return egg
	}
}
