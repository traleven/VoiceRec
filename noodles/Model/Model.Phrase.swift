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
		var comment : String {
			get { meta.comment ?? "" }
			set { meta.comment = newValue }
		}
		var baseAudio : URL? { audio(Settings.language.base) }
		var targetAudio : URL? { audio(Settings.language.target) }
		var baseText : String
		{
			get { text(Settings.language.base) }
			set { setText(newValue, for: Settings.language.base) }
		}
		var targetText : String {
			get { text(Settings.language.target) }
			set { setText(newValue, for: Settings.language.target) }
		}
		func audio(_ key: String) -> URL? {
			meta.audioUrl(key, relativeTo: id)
		}
		func text(_ key: String) -> String {
			meta.text[key] ?? ""
		}
		mutating func setText(_ text: String, for key: String) {
			meta.text[key] = text
		}

		struct Meta : Codable {
			var text : Dictionary<String, String> = Dictionary()
			var audio : Dictionary<String, String> = Dictionary()
			var comment : String?
			func audioUrl(_ key: String, relativeTo base: URL) -> URL? {
				if let path = audio[key] {
					return URL(fileURLWithPath: path, relativeTo: base)
				}
				return nil
			}
		}

		init(id: URL) {
			self.id = id
			self.meta = FileUtils.isPhraseDirectory(id)
				? PersistentObject.load(FileUtils.getMetaFile(for: id))
				: Meta()
		}

		func save() {
			FileUtils.ensureDirectory(id)
			PersistentObject.save(meta, to: FileUtils.getMetaFile(for: id))
		}
	}
}
