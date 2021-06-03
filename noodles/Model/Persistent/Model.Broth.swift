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
		//private(set) var meta : Meta
		//var name : String { self.meta.name }
		//var author : String { self.meta.author }

		struct Meta : Codable {
			private(set) var name : String
			private(set) var author : String
		}

		init(id: URL) {
			self.id = id
			self.audioFile = id
			self.avAsset = AVURLAsset(url: id)
			//self.audioFile = id.appendingPathComponent("audio.m4a")
			//let metaFile = FileUtils.getMetaFile(for: id)
			//self.meta = PersistentObject.load(metaFile)
		}

		func save() {
			FileUtils.ensureDirectory(id)
			//PersistentObject.save(meta, to: FileUtils.getMetaFile(for: id))
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
			loadAsyncCommonValue(for: .commonKeyArtist, onValueLoaded)
		}

		func loadAsyncTitle(_ onValueLoaded: @escaping (String?) -> Void) {
			loadAsyncCommonValue(for: .commonKeyTitle, {
				onValueLoaded($0 ?? id.lastPathComponentWithoutExtension)
			})
		}

		private func loadAsyncCommonValue<T>(for key: AVMetadataKey, _ onValueLoaded: @escaping (T?) -> Void) {
			avAsset.loadValuesAsynchronously(forKeys: ["commonMetadata"]) {
				switch avAsset.statusOfValue(forKey: "commonMetadata", error: nil) {
				case .loaded:
					let metadata = avAsset.commonMetadata
					let items = AVMetadataItem.metadataItems(from: metadata, withKey: key, keySpace: AVMetadataKeySpace.common)
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
