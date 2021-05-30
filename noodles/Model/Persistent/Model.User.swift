//
//  Model.User.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 10.12.20.
//

import Foundation

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
		var name : String { meta.name }
		var email : String? { meta.email }
		var from : String? { meta.from }
		var lives : String? { meta.lives }
		var base : String { meta.base }
		var target : String { meta.target }
		var sequence : String { meta.sequence }
		var icon : Data? { meta.icon }
		subscript(_ language: String) -> String? {
			meta.languages[language]
		}

		func makeIterator() -> some IteratorProtocol {
			meta.languages.makeIterator()
		}

		struct Meta : Codable {
			var name : String
			var email : String?
			var from : String?
			var lives : String?
			var languages : Dictionary<String, String> = Dictionary()
			var base : String
			var target : String
			var sequence : String = "ABABB"
			var icon : Data?
		}

		init(id: URL) {
			self.id = id
			self.meta = PersistentObject.load(id)
		}

		func save() {
			FileUtils.ensureDirectory(id.deletingLastPathComponent())
			PersistentObject.save(meta, to: id)
		}
	}
}
