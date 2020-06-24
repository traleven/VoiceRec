//
//  PhraseListView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 18.06.20.
//

import SwiftUI

struct PhraseListView: View {
	var name: String?
	var path: URL?
	@State var selectionIdx: Int?
	@Binding var parentSelection: Int?

	var body: some View {
		VStack() {
			List(Phrase.fetch(path), id: \.id) {(phrase) in
				ZStack() {
					NavigationLink(destination: PhraseEditView(phrase: phrase, parentSelection: self.$selectionIdx), tag: phrase.idx, selection: self.$selectionIdx) {
						EmptyView()
					}
					PhraseEntry(phrase: phrase)
				}
				.contentShape(Rectangle())
			}
			.navigationBarTitle(Text(name ?? ""), displayMode: .inline)
			.navigationBarHidden(path == nil)
			.navigationBarBackButtonHidden(true)
			.navigationBarItems(leading:
				Button(action: {
					withAnimation { () -> Void in
						self.parentSelection = nil
					}
				}) {
					Text("< Back")
				}
			)
		}
    }
}

struct PhraseListView_Previews: PreviewProvider {
    static var previews: some View {
		PhraseListView(path: FileUtils.getDefaultsDirectory(.phrases), parentSelection: .constant(nil))
    }
}
