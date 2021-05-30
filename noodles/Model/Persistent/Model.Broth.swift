//
//  Model.Broth.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 08.12.20.
//

import Foundation

extension Model {
	/// Background audio (music) used to add a specific "taste"
	/// to the `Noodle`s in a `Bowl`
	struct Broth : Equatable, GlobalIdentifiable, IdInitializable, Traversable, Savable {
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
		private(set) var audioFile : URL
		private(set) var meta : Meta
		var name : String { self.meta.name }

		struct Meta : Codable {
			private(set) var name : String
		}

		init(id: URL) {
			self.id = id
			self.audioFile = id.appendingPathComponent("audio.m4a")
			let metaFile = FileUtils.getMetaFile(for: id)
			self.meta = PersistentObject.load(metaFile)
		}

		func save() {
			FileUtils.ensureDirectory(id)
			PersistentObject.save(meta, to: FileUtils.getMetaFile(for: id))
		}
	}
}
