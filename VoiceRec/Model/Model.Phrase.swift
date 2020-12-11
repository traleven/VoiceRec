//
//  Model.Phrase.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 09.12.20.
//

import Foundation

extension Model {
	struct Phrase : Equatable, GlobalIdentifiable, IdInitializable, Traversable, Savable {
		static func getBy(id: URL) -> Self? {
			return Self(id: id)
		}

		static func == (lhs: Self, rhs: Self) -> Bool {
			return lhs.id == rhs.id
		}
		
		internal static func getChildren(_ id: URL) -> [URL] {
			return FileUtils.relativeContentsOfDirectory(id)
		}

		private(set) var id : URL
		private var meta : Meta
		var name : String
		{
			let base = Settings.language.base
			let target = Settings.language.target
			return meta.text[base] ?? meta.text[target] ?? ""
		}
		func audio(_ key: String) -> URL? {
			meta.audioUrl(key, relativeTo: id)
		}

		struct Meta : Codable {
			private(set) var text : Dictionary<String, String> = Dictionary()
			private(set) var audio : Dictionary<String, String> = Dictionary()
			func audioUrl(_ key: String, relativeTo base: URL) -> URL? {
				if let path = audio[key] {
					return URL(fileURLWithPath: path, relativeTo: base)
				}
				return nil
			}
		}

		init(id: URL) {
			self.id = id
			self.meta = PersistentObject.load(id.appendingPathComponent("meta.json"))
		}

		func save() {
			FileUtils.ensureDirectory(id)
			PersistentObject.save(meta, to: id.appendingPathComponent("meta.json"))
		}
	}
}

extension URL {
	var localized : URL {
		if self.baseURL == FileUtils.documentsDirectory {
			return self
		}
		return self
	}
}
