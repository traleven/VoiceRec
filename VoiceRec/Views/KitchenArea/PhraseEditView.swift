//
//  PhraseEditView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 05.06.20.
//

import SwiftUI

struct PhraseEditView: View {
	var phrase: Doughball
	@Binding var parentSelection: Int?

    var body: some View {
		VStack() {
			Text(phrase.baseText ?? "")
			Text(phrase.targetText ?? "")
		}
		.navigationBarTitle(Text(phrase.baseText ?? ""), displayMode: .inline)
		.navigationBarHidden(false)
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

struct PhraseEditView_Previews: PreviewProvider {
    static var previews: some View {
		PhraseEditView(phrase: Doughball.make(0, ["English" : "Test", "Chinese" : "Test"]), parentSelection: .constant(0))
    }
}
