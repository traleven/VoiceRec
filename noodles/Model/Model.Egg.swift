//
//  ModelMess.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 08.12.20.
//

import Foundation
import AVFoundation

extension Model {
	struct Egg : Equatable, GlobalIdentifiable, IdInitializable, Traversable {
		static func getBy(id: URL) -> Self? {
			return Egg(id: id)
		}

		static func == (lhs: Self, rhs: Self) -> Bool {
			return lhs.id == rhs.id
		}

		internal static func getChildren(_ id: URL) -> [URL] {
			return FileUtils.relativeContentsOfDirectory(id)
		}

		enum SupportedType : String {
			case text = "txt"
			case json = "json"
			case audio = "m4a"
			case directory
			case inbox
			case unknown
		}

		private(set) var id : URL
		private(set) var type : SupportedType
		var children : [URL] { Egg.getChildren(id) }
		var name : String { _name.getName(id) }
		private var _name : FileNameResolver

		fileprivate static func getType(_ id: URL) -> SupportedType {
			if (id == FileUtils.getDirectory(.inbox)) {
				return .inbox
			}
			if (try? id.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false {
				return .directory
			}
			switch id.pathExtension {
				case SupportedType.text.rawValue: return .text
				case SupportedType.json.rawValue: return .json
				case SupportedType.audio.rawValue: return .audio
				default: return .unknown
			}
		}

		private init(id: URL, type: SupportedType, name: FileNameResolver) {
			self.id = id
			self.type = type
			self._name = name
		}

		init(id: URL) {
			let type : SupportedType = Egg.getType(id)
			var nameResolver : FileNameResolver
			switch type {
			case .inbox: nameResolver = ConstName(name: "Inbox")
			case .directory: nameResolver = DirectoryName()
			case .audio: nameResolver = AudioName()
			case .text, .json: nameResolver = TextName()
			default: nameResolver = DefaultName()
			}

			self.init(id: id, type: type, name: nameResolver)
		}

		func loadAsyncDuration(_ onValueLoaded: @escaping (Double) -> Void) {
			let audioAsset = AVURLAsset.init(url: id);
			audioAsset.loadValuesAsynchronously(forKeys: ["duration"]) {
				let avduration = audioAsset.duration
				DispatchQueue.main.async {
					onValueLoaded(avduration.seconds)
				}
			}
		}

		fileprivate struct DefaultName : FileNameResolver {
			func getName(_ source : URL) -> String {
				return source.deletingPathExtension().lastPathComponent
			}
		}

		fileprivate struct AudioName : FileNameResolver {
			func getName(_ source : URL) -> String {
				let attributes = try? FileManager.default.attributesOfItem(atPath: source.path)
				return "\((attributes?[FileAttributeKey.creationDate] as? Date)?.toString(withFormat: "yyyy-MM-dd HH:mm:ss") ?? "Recording")"
			}
		}

		fileprivate struct TextName : FileNameResolver {
			func getName(_ source : URL) -> String {
				let content = (try? String(contentsOf: source)) ?? source.deletingPathExtension().lastPathComponent
				return content.count > 42 ? content.prefix(39).appending("...") : content
			}
		}

		fileprivate struct DirectoryName : FileNameResolver {
			func getName(_ source : URL) -> String {
				for item in Egg.getChildren(source) {
					if Egg.getType(item) == .text {
						return TextName().getName(item)
					}
				}
				return DefaultName().getName(source)
			}
		}

		fileprivate struct ConstName : FileNameResolver {
			let name: String
			func getName(_ : URL) -> String {
				return name
			}
		}
	}
}
