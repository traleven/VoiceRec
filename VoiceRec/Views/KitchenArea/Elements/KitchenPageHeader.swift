//
//  KitchenPageHeader.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 05.06.20.
//

import SwiftUI

struct KitchenPageHeader: View {
	var name: String

    var body: some View {
		HStack() {
			Button(action: {
			}) {
				Image("menu_small")
					.foregroundColor(.black)
					.scaledToFit()
					.aspectRatio(contentMode: .fit)
					.padding()
			}
			Spacer()
			Text(name)
				.font(.largeTitle)
				.bold()
			Spacer()
			Button(action: {
			}) {
				Image("language_toggle_small")
					.foregroundColor(.black)
					.scaledToFit()
					.aspectRatio(contentMode: .fit)
					.padding()
			}
			Button(action: {
			}) {
				Image("multiselect_small")
					.foregroundColor(.black)
					.scaledToFit()
					.aspectRatio(contentMode: .fit)
					.padding()
			}
		}
    }
}

struct KitchenPageHeader_Previews: PreviewProvider {
    static var previews: some View {
		KitchenPageHeader(name: "Kitchen Page")
		.previewLayout(.fixed(width: 300, height: 70))
    }
}
