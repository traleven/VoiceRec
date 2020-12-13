//
//  PhraseBrowserView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 18.06.20.
//

import SwiftUI

struct PhraseBrowserView: View {
    var body: some View {
		NavigationView() {
			PhraseListView()
				.border(Color.gray, width: 0.5)
		}
		.navigationViewStyle(StackNavigationViewStyle())
	}
}

struct PhraseBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        PhraseBrowserView()
    }
}
