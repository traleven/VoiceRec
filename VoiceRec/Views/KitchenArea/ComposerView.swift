//
//  ComposerView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 18.06.20.
//

import SwiftUI
import SwiftUIX
import ASCollectionView

struct ComposerView: View {
	@State var musicVolume: Double = 0.5
	@State var voiceVolume: Double = 0.8
	@State var delayBetween: Double = 3
	@State var delayWithin: Double = 1
	@State var randomize: Bool = true

    var body: some View {
		Form() {
			HStack() {
				Text("Music volume: ")
					//.frame(minWidth: 92, idealWidth: 102, maxWidth: 112)
				Slider(value: self.$musicVolume, in: 0...1) {
					Text("\(self.musicVolume)")
				}
			}
			HStack() {
				Text("Phrases volume: ")
					.frame(minWidth: 92, idealWidth: 102, maxWidth: 112)
				Slider(value: self.$voiceVolume, in: 0...1) {
					Text("\(self.voiceVolume)")
				}
			}
			HStack() {
				Text("Delay between sequences: ")
				Slider(value: self.$delayBetween, in: 0...5, minimumValueLabel: Text("0"), maximumValueLabel: Text("5")) {
					Text("\(self.delayBetween)")
				}
			}
			HStack() {
				Text("Delay within sequences: ")
				Slider(value: self.$delayWithin, in: 0...5, minimumValueLabel: Text("0"), maximumValueLabel: Text("5")) {
					Text("\(self.delayWithin)")
				}
			}
			Toggle(isOn: self.$randomize) {
				Text("Randomize phrase order: ")
			}
		}
    }
}

struct ComposerView_Previews: PreviewProvider {
    static var previews: some View {
		ComposerView()
			.previewDevice("iPhone 12")
    }
}
