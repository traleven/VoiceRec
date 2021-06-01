//
//  DB.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 06.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

class DB: NSObject {

	static var settings: UserDefaults! = UserDefaults.init(suiteName: "settings")

	static var phrases: DictionaryDB! = DictionaryDB(withUrl: FileUtils.getDocumentsDirectory().appendingPathComponent("phrases.json", isDirectory: false), andDefaultValue: "")

	static var music: DictionaryDB! = DictionaryDB(withUrl: FileUtils.getDocumentsDirectory().appendingPathComponent("music.json", isDirectory: false), andDefaultValue: "")

	static var options: DictionaryDB! = DictionaryDB(withUrl: FileUtils.getDocumentsDirectory().appendingPathComponent("options.json", isDirectory: false), andDefaultValue: "")


	static var presets: ArrayDB! = ArrayDB(withUrl:FileUtils.getDocumentsDirectory().appendingPathComponent("presets.json", isDirectory: false))

	let url: URL!

	init(withUrl: URL!) {
		url = withUrl
		super.init()
	}

	func flush() {
	}
}


class Settings {
	class music {
		static var volume: Float {
			get { return DB.settings.float(forKey: "music.volume") }
			set { DB.settings.set(newValue, forKey: "music.volume") }
		}
	}
	class voice {
		static var volume: Float {
			get { return DB.settings.float(forKey: "voice.volume") }
			set { DB.settings.set(newValue, forKey: "voice.volume") }
		}
	}
	class phrase {
		static var random: Bool {
			get { return DB.settings.bool(forKey: "phrase.random") }
			set { DB.settings.set(newValue, forKey: "phrase.random") }
		}
		static var defaultShape: Shape {
			get { return Shape(dna: DB.options.getValue(forKey: "lesson.defaultShape")) }
			set { DB.options.setValue(forKey: "lesson.defaultShape", value: newValue.dna) }
		}
		class delay {
			static var inner: Double {
				get { return DB.settings.double(forKey: "phrase.delay.inner") }
				set { DB.settings.set(newValue, forKey: "phrase.delay.inner") }
			}
			static var outer: Double {
				get { return DB.settings.double(forKey: "phrase.delay.outer") }
				set { DB.settings.set(newValue, forKey: "phrase.delay.outer") }
			}
		}
	}
	class language {
		static var preferBase: Bool {
			get { return DB.options.getValue(forKey: "language.preferBase") != "NO" }
			set { DB.options.setValue(forKey: "language.preferBase", value: newValue ? "YES" : "NO") }
		}
		static var base: Language {
			get { return Language(withCode: DB.options.getValue(forKey: "language.base")) }
			set { DB.options.setValue(forKey: "language.base", value: newValue.code) }
//			get { return DB.settings.string(forKey: "language.native") ?? "English" }
//			set { DB.settings.set(newValue, forKey: "language.native") }
		}
		static var target: Language {
			get { return Language(withCode: DB.options.getValue(forKey: "language.target")) }
			set { DB.options.setValue(forKey: "language.target", value: newValue.code) }
//			get { return DB.settings.string(forKey: "language.foreign") ?? "Chinese" }
//			set { DB.settings.set(newValue, forKey: "language.foreign") }
		}
		class func getLanguage(_ languageCode: Character) -> Language {
			return languageCode == "E" || languageCode == "N" || languageCode == "B" ? base : target
		}
		class func getLanguage(_ language: String) -> Language {
			return language == "Base" ? base : language == "Target" ? target : Language(withCode: language)
		}
	}
}
