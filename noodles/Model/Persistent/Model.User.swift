//
//  Model.User.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 10.12.20.
//

import Foundation
import UIKit

extension Model {
	struct User : Equatable, GlobalIdentifiable, IdInitializable, Savable, Sequence {
		static func getBy(id: URL) -> Self? {
			return Self(id: id)
		}

		static func == (lhs: Self, rhs: Self) -> Bool {
			return lhs.id == rhs.id
		}

		private(set) var id : URL
		private var meta : Meta
		var name : String {
			get { meta.name }
			set { meta.name = newValue }
		}
		var email : String? {
			get { meta.email }
			set { meta.email = newValue }
		}
		var from : String? {
			get { meta.from }
			set { meta.from = newValue }
		}
		var lives : String? {
			get { meta.lives }
			set { meta.lives = newValue }
		}
		var base : Language {
			get { Language(withCode: meta.base) }
			set { meta.base = newValue.code }
		}
		var target : Language {
			get { Language(withCode: meta.target) }
			set { meta.target = newValue.code }
		}
		var sequence : Shape {
			get { Shape(dna: meta.sequence ?? "ABABB") }
			set { meta.sequence = newValue.dna }
		}
		var icon : UIImage? {
			get { meta.icon != nil ? UIImage(data: meta.icon!) : nil }
			set { meta.icon = newValue?.pngData() }
		}
		subscript(_ language: Language) -> String? {
			get { meta.languages[language.code] ?? meta.languages.first(where: { Language(withCode: $0.key) == language })?.value }
			set {
				meta.languages[language.code] = newValue
				while let key = meta.languages.first(
						where: { $0.key != language.code && Language(withCode: $0.key) == language }
				)?.key {
					meta.languages.removeValue(forKey: key)
				}
			}
		}
		var languages : [Language] {
			meta.languages.keys
				.map({ Language(withCode: $0) })
				.sorted(by: languageSorting(lhv:rhv:))
		}
		mutating func remove(language: Language) {
			let key = meta.languages.first(where: { Language(withCode: $0.key) == language })?.key
			meta.languages.removeValue(forKey: key ?? language.code)
		}
		var tutors : [Model.User] { [] }

		func makeIterator() -> some IteratorProtocol {
			meta.languages.makeIterator()
		}

		struct Meta : Codable {
			var name : String
			var email : String?
			var from : String? = "Earth, Solar System"
			var lives : String? = "Earth, Solar System"
			var languages : Dictionary<String, String> = Dictionary()
			var base : String
			var target : String
			var sequence : String? = "ABABB"
			var icon : Data?
		}

		init(id: URL) {
			self.id = id
			self.meta = PersistentObject.load(id)
		}

		init(id: URL, name: String, base: Language, target: Language) {
			self.id = id
			self.meta = Meta(name: name, base: base.code, target: target.code)
			self.meta.languages[base.code] = "Mother tongue"
			self.meta.languages[target.code] = "Newbie"
		}

		static private(set) var Me: Model.User = Model.User(id: FileUtils.getDirectory(.users).appendingPathComponent("me.json"))

		func save() {
			FileUtils.ensureDirectory(id.deletingLastPathComponent())
			PersistentObject.save(meta, to: id)
			if self.id == Self.Me.id {
				Self.Me = self
			}
		}

		private func languageSorting(lhv: Language, rhv: Language) -> Bool {
			return lhv == self.base || rhv != self.base && lhv == self.target
				|| rhv != self.base && rhv != self.target && lhv.code < rhv.code
		}
	}
}
