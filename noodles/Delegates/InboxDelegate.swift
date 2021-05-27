//
//  InboxDelegate.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 20.05.21.
//

import Foundation

class InboxDelegate : NSObject {

	func addText(_ text: String, to parent: Egg?) {
	}


	func startRecording(to parent: Egg?, progress: ((Float, Float) -> Void)?) {
	}


	func stopRecording() {
	}


	func playAudioEgg(_ egg: Egg, progress: ((Float, Float) -> Void)?) {
	}


	func readTextEgg(_ egg: Egg) {
	}


	func delete(_ egg: Egg) {
	}


	func share(_ egg: Egg) {
	}
}
