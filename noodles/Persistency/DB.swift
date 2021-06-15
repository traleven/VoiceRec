//
//  DB.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 06.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

class DB: NSObject {

	static var options   = DictionaryDB(with: FileUtils.getConfigFile(.options),  andDefaultValue: "")
	static var numerics  = DictionaryDB(with: FileUtils.getConfigFile(.numerics), andDefaultValue: Float(0.5))
	static var presets   =     StringDB(with: FileUtils.getConfigFile(.presets))
	static var languages =   LanguageDB(with: FileUtils.getConfigFile(.languages))
	static var proficiencies = StringDB(with: FileUtils.getConfigFile(.proficiencies), content: [
		"Newbie", "Beginner", "Intermediate", "Advanced", "Fluent", "Mother tongue"
	])

	let url: URL

	init(with url: URL) {
		self.url = url
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
		DB.languages.flush()
		DB.proficiencies.flush()
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
	}
}
