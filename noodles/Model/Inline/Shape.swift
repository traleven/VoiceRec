//
//  Shape.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 08.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation
import UIKit.UIColor

/// A specific sequence of Native and Foreign audio
/// repetiotions describing a "shape" of a `Noodle`
struct Shape : Codable {
	var dna : String
	var count : Int { dna.count }
}

extension Shape {

	func makeIterator<Element>(base: Element?, target: Element?) -> DNAIterator<Element> {
		return DNAIterator(shape: self, base: base, target: target)
	}

	struct DNAIterator<Element> : IteratorProtocol {
		private let dna : String
		private var idx : String.Index
		private var end : String.Index

		private var base : Element?
		private var target: Element?

		init(shape: Shape, base: Element?, target: Element?) {
			self.dna = shape.dna
			self.idx = shape.dna.startIndex
			self.end = shape.dna.endIndex
			self.base = base
			self.target = target
		}

		mutating func next() -> Element? {
			guard idx < end else {
				return nil
			}
			defer {
				idx = dna.index(after: idx)
			}
			switch dna[idx] {
			case "A", "N": return base
			case "B", "F": return target
			default:
				return nil
			}
		}
	}

	var colorCoded: NSAttributedString {
		let s = NSMutableAttributedString(string: dna)
		for range in (dna as NSString).range(ofAll: "B") {
			s.addAttribute(.foregroundColor, value: UIColor.errorText!, range: range)
		}
		return s
	}
}
