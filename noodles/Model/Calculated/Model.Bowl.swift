//
//  Model.Bowl.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 10.12.20.
//

import Foundation

extension Model {
	/// A mix of `Noodle`s in a specific `Broth` with a specific `Spices`
	/// that is used for the language learning session
	struct Bowl : Sequence {
		typealias Element = Model.Noodle
		typealias Iterator = AnyIterator<Model.Noodle>

		private(set) var noodles : [Model.Noodle]
		private(set) var broth : Model.Broth
		private(set) var spices : Spices

		init(noodles: [Model.Noodle], broth: Model.Broth, spices: Spices) {
			self.noodles = noodles
			self.broth = broth
			self.spices = spices
		}

		init(lesson: Model.Recipe) {
			self.noodles = lesson.map({ Model.Noodle(phrase: Model.Phrase(id: $0), shape: lesson.shape) })
			self.broth = Model.Broth(id: lesson.music!)
			self.spices = lesson.spices
		}

		func makeIterator() -> Iterator {
			return spices.randomize
				? AnyIterator(InfiniteRandomIterator(noodles: self.noodles))
				: AnyIterator(InfiniteLoopIterator(noodles: self.noodles))
		}

		struct InfiniteRandomIterator : IteratorProtocol {
			typealias Element = Model.Noodle

			let noodles : [Model.Noodle]

			mutating func next() -> Model.Noodle? {
				return noodles[Int.random(in: 0..<noodles.count)]
			}
		}

		struct InfiniteLoopIterator : IteratorProtocol {
			typealias Element = Model.Noodle

			let noodles : [Model.Noodle]
			var idx : Int = 0

			mutating func next() -> Model.Noodle? {
				let result = noodles[idx]
				idx = (idx + 1) % noodles.count
				return result
			}
		}
	}
}
