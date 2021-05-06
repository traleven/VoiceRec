//
//  Model.Bowl.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 10.12.20.
//

import Foundation

extension Model {
	struct Bowl : Sequence {
		private(set) var noodles : [Model.Noodle]
		private(set) var broth : Model.Broth
		private(set) var spices : Spices

		func makeIterator() -> some IteratorProtocol {
			return spices.randomize
				? AnyIterator(InfiniteRandomIterator(noodles: self.noodles))
				: AnyIterator(InfiniteLoopIterator(noodles: self.noodles))
		}

		struct InfiniteRandomIterator : IteratorProtocol {
			let noodles : [Model.Noodle]

			mutating func next() -> Model.Noodle? {
				return noodles[Int.random(in: 0..<noodles.count)]
			}
		}

		struct InfiniteLoopIterator : IteratorProtocol {
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
