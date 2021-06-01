//
//  Model.Recipe.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 09.12.20.
//

import Foundation

extension Model {
	/// A conteiner of all the required ingridients used
	/// to cook a `Bowl` of `Noodle`s
	struct Recipe : Equatable, GlobalIdentifiable, IdInitializable, Traversable, Savable, Sequence {

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
		
		var name : String { get { meta.name } set { meta.name = newValue } }
		var phraseCount : Int { meta.count }
		subscript(_ idx: Int) -> URL { meta[idx, at: id.baseURL] }
		var music : URL? {
			get { meta.broth.isEmpty ? nil : URL(fileURLWithPath: ".", relativeTo: id.baseURL).appendingPathComponent(meta.broth) }
			set {
				if let base = id.baseURL, let newValue = newValue, let relativePath = newValue.relativePath(relativeTo: base) {
					meta.broth = relativePath
				} else {
					meta.broth = ""
				}
			}
		}

		struct Meta : Codable {
			var name : String = ""
			var shape : Shape
			var spices : Spices
			var broth : String = ""
			var phrases : [String] = []
			
			var count : Int { phrases.count }
			subscript(_ idx: Int, at base: URL?) -> URL {
				let path = phrases[idx]
				return URL(fileURLWithPath: ".", relativeTo: base).appendingPathComponent(path)
			}

			init() {
				self.shape = Settings.phrase.defaultShape
				self.spices = .init(
					musicVolume: Settings.music.volume,
					voiceVolume: Settings.voice.volume,
					delayBetween: Settings.phrase.delay.inner,
					delayWithin: Settings.phrase.delay.outer,
					randomize: Settings.phrase.random
				)
			}
		}

		init(id: URL) {
			self.id = id
			self.meta = FileUtils.isLessonDirectory(id)
				? PersistentObject.load(FileUtils.getMetaFile(for: id))
				: Meta()
		}

		mutating func addPhrase(id: URL) {
			if let base = self.id.baseURL {
				if let relativePath = id.relativePath(relativeTo: base) {
					meta.phrases.append(relativePath)
				}
			} else {
				NSLog("Serializing absolute path: \(id) for \(self.id)")
				meta.phrases.append(id.relativePath)
			}
		}

		mutating func removePhrase(id: URL) {
			let path = id.path
			meta.phrases.removeAll(where: { path.hasSuffix($0) })
		}

		func save() {
			FileUtils.ensureDirectory(id)
			PersistentObject.save(meta, to: FileUtils.getMetaFile(for: id))
		}

		__consuming func makeIterator() -> RelativePathIterator {
			return RelativePathIterator(paths: meta.phrases, baseUrl: id.baseURL)
		}

		func contains(_ phrase: URL) -> Bool {
			return self.contains(where: { phrase == $0 })
		}

		struct RelativePathIterator : IteratorProtocol {
			typealias Element = URL
			let paths : [String]
			let baseUrl : URL?
			var idx : Int = 0

			mutating func next() -> URL? {
				guard idx < paths.count else {
					return nil
				}
				let result = URL(fileURLWithPath: ".", relativeTo: baseUrl).appendingPathComponent(paths[idx])
				idx += 1
				return result
			}
		}
	}
}
