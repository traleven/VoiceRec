//
//  Model.Recipe.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 09.12.20.
//

import Foundation

extension Model {
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
		var name : String { meta.name }
		var phraseCount : Int { meta.count }
		subscript(_ idx: Int) -> URL { meta[idx, at: id.baseURL] }

		struct Meta : Codable {
			private(set) var name : String
			private(set) var shape : Shape
			private(set) var spices : Spices
			private(set) var broth : String
			private(set) var phrases : [String]
			
			var count : Int { phrases.count }
			subscript(_ idx: Int, at base: URL?) -> URL {
				let path = phrases[idx]
				return URL(fileURLWithPath: path, relativeTo: base)
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

		func makeIterator() -> some IteratorProtocol {
			return RelativePathIterator(paths: meta.phrases, baseUrl: id.baseURL)
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
				let result = URL(fileURLWithPath: paths[idx], relativeTo: baseUrl)
				idx += 1
				return result
			}
		}
	}
}
