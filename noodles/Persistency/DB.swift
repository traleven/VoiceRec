//
//  DB.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 06.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

class DB: NSObject {

	static var options: DictionaryDB! = DictionaryDB(withUrl: FileUtils.getDocumentsDirectory().appendingPathComponent("options.json", isDirectory: false), andDefaultValue: "")

	static var numerics: DictionaryDB! = DictionaryDB(withUrl: FileUtils.getDocumentsDirectory().appendingPathComponent("numerics.json", isDirectory: false), andDefaultValue: Float(0.5))

	static var presets: ArrayDB! = ArrayDB(withUrl:FileUtils.getDocumentsDirectory().appendingPathComponent("presets.json", isDirectory: false))

	let url: URL!

	init(withUrl: URL!) {
		url = withUrl
		super.init()
	}

	open func flush() {
	}
}


class Settings {
	class func saveAll() {
		DB.options.flush()
		DB.numerics.flush()
		DB.presets.flush()
	}

	class music {
		static var volume: Float {
			get { return DB.numerics.getValue(forKey: "music.volume") }
			set { DB.numerics.setValue(newValue, forKey: "music.volume") }
		}
	}
	class voice {
		static var volume: Float {
			get { return DB.numerics.getValue(forKey: "voice.volume") }
			set { DB.numerics.setValue(newValue, forKey: "voice.volume") }
		}
	}
	class phrase {
		static var random: Bool {
			get { return DB.options.getValue(forKey: "phrase.random") != "NO" }
			set { DB.options.setValue(newValue ? "YES" : "NO", forKey: "phrase.random") }
		}
		static var defaultShape: Shape {
			get { return Shape(dna: DB.options.getValue(forKey: "lesson.defaultShape")) }
			set { DB.options.setValue(forKey: "lesson.defaultShape", value: newValue.dna) }
		}
		class delay {
			static var inner: Float {
				get { return DB.numerics.getValue(forKey: "phrase.delay.inner") }
				set { DB.numerics.setValue(newValue, forKey: "phrase.delay.inner") }
			}
			static var outer: Float {
				get { return DB.numerics.getValue(forKey: "phrase.delay.outer") }
				set { DB.numerics.setValue(newValue, forKey: "phrase.delay.outer") }
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
		}
		static var target: Language {
			get { return Language(withCode: DB.options.getValue(forKey: "language.target")) }
			set { DB.options.setValue(forKey: "language.target", value: newValue.code) }
		}
		class func getLanguage(_ languageCode: Character) -> Language {
			return languageCode == "E" || languageCode == "N" || languageCode == "A" ? base : target
		}
		class func getLanguage(_ language: String) -> Language {
			return language == "Base" ? base : language == "Target" ? target : Language(withCode: language)
		}
	}
}
