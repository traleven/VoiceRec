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
		var name : String { meta.name }
		var email : String? { meta.email }
		var from : String? { meta.from }
		var lives : String? { meta.lives }
		var base : Language { Language(withCode: meta.base) }
		var target : Language { Language(withCode: meta.target) }
		var sequence : String { meta.sequence ?? "ABABB" }
		var icon : UIImage? { meta.icon != nil ? UIImage(data: meta.icon!) : nil }
		subscript(_ language: Language) -> String? {
			meta.languages[language.code]
		}
		var languages : [String] { Array<String>(meta.languages.keys) }
		var tutors : [Model.User] { [] }

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
			var sequence : String? = "ABABB"
			var icon : Data?
		}

		init(id: URL) {
			self.id = id
			self.meta = PersistentObject.load(id)
		}

		static var Me: Model.User {
			Model.User(id: FileUtils.getDirectory(.users).appendingPathComponent("me.json"))
		}

		func save() {
			FileUtils.ensureDirectory(id.deletingLastPathComponent())
			PersistentObject.save(meta, to: id)
		}
	}
}
