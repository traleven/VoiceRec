//
//  Model.Noodle.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 10.12.20.
//

import Foundation

extension Model {
	struct Noodle : Sequence {
		internal static func getChildren(_ id: URL) -> [URL] {
			return FileUtils.relativeContentsOfDirectory(id)
		}

		private(set) var phrase : Model.Phrase
		private(set) var shape : Shape

		var count : Int { shape.dna.count }
		subscript(_ idx : Int) -> URL? {
			switch shape.dna[shape.dna.index(shape.dna.startIndex, offsetBy: idx)] {
			case "A", "N" : return self.phrase.audio(Settings.language.base)
			case "B", "F" : return self.phrase.audio(Settings.language.target)
			default: return nil
			}
		}

		func makeIterator() -> some IteratorProtocol {
			return DNAIterator(noodle: self)
		}

		struct DNAIterator : IteratorProtocol {
			typealias Element = URL
			let noodle : Noodle
			var idx : String.Index
			var end : String.Index

			init(noodle: Noodle) {
				self.noodle = noodle
				self.idx = noodle.shape.dna.startIndex
				self.end = noodle.shape.dna.endIndex
			}

			mutating func next() -> URL? {
				guard idx < end else {
					return nil
				}
				let result : URL?
				switch noodle.shape.dna[idx] {
				case "A", "N": result = noodle.phrase.audio(Settings.language.base)
				case "B", "F": result = noodle.phrase.audio(Settings.language.target)
				default:
					result = nil
				}
				idx = noodle.shape.dna.index(after: idx)
				return result
			}
		}
	}
}
