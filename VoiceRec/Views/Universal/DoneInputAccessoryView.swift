//
//  DoneInputAccessoryView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 19.06.20.
//

import SwiftUI

struct DoneInputAccessoryView: View {
    var body: some View {
		HStack() {
			Spacer()
			Button(action: {
				UIApplication.shared.hideKeyboard()
			}) {
				Text("Done").padding()
			}
		}
		.background(
			Rectangle()
				.foregroundColor(.systemGroupedBackground)
		)
    }
}

struct DoneInputAccessoryView_Previews: PreviewProvider {
    static var previews: some View {
        DoneInputAccessoryView()
			.previewLayout(.fixed(width: 480, height: 60))
    }
}
