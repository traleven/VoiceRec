//
//  OpusTranscoder.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 05.04.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation
import MediaPlayer

class OpusTranscoder: NSObject {

	static let SAMPLE_RATE : opus_int32 = 48000
	static let FRAME_SIZE : opus_int32 = 5760
	static let CHANNELS : opus_int32 = 1


//	class func convertOpus(_ data: AudioData) {
//
//		transcode(data.url!.path, data.url.appendingPathExtension(".wav").path)
//		return
//	}

	class func convert(opusFile: URL, toM4A: URL, completionHandler: @escaping () -> Void) {

		let tmp = FileUtils.getTempFile(withExtension: "wav")
		transcode(opusFile.path, tmp.path)

		let composition = AVMutableComposition()

		let musicTrack:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID:kCMPersistentTrackID_Invalid)!

		let newAsset = AVURLAsset(url: tmp)
		let range = CMTimeRangeMake(start: CMTime.zero, duration: newAsset.duration)
		let end = musicTrack.timeRange.end
		if let track = newAsset.tracks(withMediaType: AVMediaType.audio).first {
			try! musicTrack.insertTimeRange(range, of: track, at: end)
		}

		let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)!
		assetExport.shouldOptimizeForNetworkUse = true
		assetExport.outputFileType = AVFileType.m4a
		assetExport.outputURL = toM4A

		assetExport.exportAsynchronously() {
			try? FileManager.default.removeItem(at: tmp)
			completionHandler()
		}
	}
}
