//
//  MusicEntry.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 22.06.20.
//

import SwiftUI

struct MusicEntry: View {
	var music: Broth

    var body: some View {
		Text(music.name)
    }
}

struct MusicEntry_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			MusicEntry(music: Broth.fetch()[0])
		}
		.previewLayout(.fixed(width: 320, height: 70))
    }
}
