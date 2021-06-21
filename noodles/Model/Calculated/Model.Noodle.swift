//
//  Model.Noodle.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 10.12.20.
//

import Foundation

extension Model {
	/// A specific sequence of audio from `Doughball`
	/// repeated in accordance to a selected `Shape`
	struct Noodle : Sequence {
		private(set) var phrase : Model.Phrase
		private(set) var shape : Shape

		var count : Int { shape.dna.count }
		subscript(_ idx : Int) -> URL? {
			switch shape.dna[shape.dna.index(shape.dna.startIndex, offsetBy: idx)] {
			case "A", "N" : return self.phrase.audio(Model.User.Me.base)
			case "B", "F" : return self.phrase.audio(Model.User.Me.target)
			default: return nil
			}
		}

		func makeIterator() -> Shape.DNAIterator<URL> {
			return shape.makeIterator(base: phrase.baseAudio, target: phrase.targetAudio)
		}
	}
}
