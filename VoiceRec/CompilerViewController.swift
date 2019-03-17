//
//  CompilerViewController.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 28.02.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class CompilerViewController: UIViewController {

	var musicPlayer: AudioPlayer!
	var voicePlayer: AudioPlayer!

	var music: [String] = [String]()
	var voice: [String] = [String]()

	var voiceTimer: Timer!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}


	@IBAction func doTheThing(_ sender: UIButton) {

		if (musicPlayer?.isPlaying ?? false) {
			voiceTimer?.invalidate()
			musicPlayer.stop(silent: true)
			voicePlayer.stop(silent: true)
			sender.setTitle("Play", for: .normal)
		} else {
			prepare_data()
			playMusic()
			playVoice()
			sender.setTitle("Stop", for: .normal)
		}
	}


	func prepare_data() {
		music = DB.music.getKeys(withValue: "y")
		voice = DB.phrases.getKeys(withValue: "y")
	}


	func buildMusicURL(_ forKey: String) -> URL {

		return FileUtils.getDirectory("music").appendingPathComponent(forKey)
	}


	func buildVoiceURL(_ forKey: String, language: String) -> URL {

		return FileUtils.getDirectory("recordings")
			.appendingPathComponent(forKey)
			.appendingPathComponent(language.appending(".m4a"))
	}


	func getRandom(fromArray: [String]) -> String {

		if (fromArray.count > 0) {
			let count = fromArray.count
			return fromArray[Int.random(in: 0...count-1)]
		}
		return ""
	}


	func playMusic() {

		musicPlayer = AudioPlayer(buildMusicURL(getRandom(fromArray: music)))
		musicPlayer.play(onProgress: { (_: TimeInterval, _: TimeInterval) in
		}) {
			self.playMusic()
		}
	}


	func playVoice() {

		let phrase = getRandom(fromArray: voice)

		let playNextPhraseBlock = {
			self.voiceTimer = Timer(timeInterval: TimeInterval.random(in: 3...5), repeats: false, block: { (timer: Timer) in
				timer.invalidate()
				self.voiceTimer = nil
				self.playVoice()
			})
			RunLoop.main.add(self.voiceTimer, forMode: RunLoop.Mode.default)
		}

		let playChineseBlock = {
			self.voiceTimer = Timer(timeInterval: TimeInterval.random(in: 1...3), repeats: false, block: { (timer: Timer) in
				timer.invalidate()
				self.voicePlayer = AudioPlayer(self.buildVoiceURL(phrase, language: "Chinese"))
				self.voicePlayer.play(onProgress: { (_:TimeInterval, _:TimeInterval) in }, onFinish: playNextPhraseBlock)
			})
			RunLoop.main.add(self.voiceTimer, forMode: RunLoop.Mode.default)
		}

		voicePlayer = AudioPlayer(buildVoiceURL(phrase, language: "English"))
		voicePlayer.play(onProgress: { (_:TimeInterval, _:TimeInterval) in }, onFinish: playChineseBlock)
	}
}
