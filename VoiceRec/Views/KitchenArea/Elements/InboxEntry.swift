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
			Text(egg.name)
				.multilineTextAlignment(.leading)
				.padding()
			Spacer()
		}
    }
}

struct InboxEntry_Previews: PreviewProvider {
    static var previews: some View {
		let egg = Egg()
		egg.name = "Test egg"
		egg.audioFile = Bundle.main.resourceURL
		return InboxEntry(egg: egg)
			.previewLayout(.fixed(width: 320, height: 70))
    }
}
