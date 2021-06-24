//
//  Model.Broth.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 08.12.20.
//

import Foundation
import AVFoundation

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
		private(set) var avAsset : AVAsset

		struct Meta : Codable {
			private(set) var name : String
			private(set) var author : String
		}

		init(id: URL) {
			self.id = id
			self.audioFile = id
			self.avAsset = AVURLAsset(url: id)
		}

		func save() {
			FileUtils.ensureDirectory(id)
		}

		func loadAsyncDuration(_ onValueLoaded: @escaping (TimeInterval) -> Void) {
			avAsset.loadValuesAsynchronously(forKeys: ["duration"]) {
				switch avAsset.statusOfValue(forKey: "duration", error: nil) {
				case .loaded:
					let avduration = avAsset.duration
					DispatchQueue.runOnMain {
						onValueLoaded(avduration.seconds)
					}
				default:
					return
				}
			}
		}

		func loadAsyncArtist(_ onValueLoaded: @escaping (String?) -> Void) {
			loadAsyncCommonValue(for: AVMetadataIdentifier.commonIdentifierArtist, onValueLoaded)
		}

		func loadAsyncTitle(_ onValueLoaded: @escaping (String?) -> Void) {
			loadAsyncCommonValue(for: AVMetadataIdentifier.commonIdentifierTitle, {
				onValueLoaded($0 ?? id.lastPathComponentWithoutExtension)
			})
		}

		private func loadAsyncCommonValue<T>(for identifier: AVMetadataIdentifier, _ onValueLoaded: @escaping (T?) -> Void) {
			let anyKey = AVMetadataItem.key(forIdentifier: identifier)
			let space = AVMetadataItem.keySpace(forIdentifier: identifier)
			let key = anyKey as? String ?? String(describing: anyKey)
			avAsset.loadValuesAsynchronously(forKeys: [ "metadata" ]) {
				switch avAsset.statusOfValue(forKey: "metadata", error: nil) {
				case .loaded:
					let metadata = avAsset.metadata
					let items = AVMetadataItem.metadataItems(from: metadata, withKey: key, keySpace: space)
					DispatchQueue.runOnMain {
						onValueLoaded(items.first?.value as? T)
					}
				default:
					return
				}
			}
		}
	}
}
