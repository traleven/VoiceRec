//
//  OpusTranscoder.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 05.04.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

class OpusTranscoder: NSObject {

	static let SAMPLE_RATE : opus_int32 = 48000
	static let FRAME_SIZE : opus_int32 = 5760
	static let CHANNELS : opus_int32 = 1


	class func convertOpus(_ data: AudioData) {


		transcode(data.url!.path, data.url.appendingPathExtension(".wav").path)
		return

		let opusData = FileManager.default.contents(atPath: data.url.path)!

		var opusError : opus_int32 = OPUS_OK
		let decoder = opus_decoder_create(SAMPLE_RATE, CHANNELS, &opusError)!

		var result = Data()
		result.append(decodeOpusPacket(decoder, opusData))

		try! result.write(to: data.url.appendingPathExtension(".wav"))
	}


	class func decodeOpusPacket(_ decoder: OpaquePointer, _ data: Data) -> Data {

		let result = data.withUnsafeBytes { (_ unsafeData: UnsafePointer<UInt8>) -> Data? in

			var pcmData = Data(capacity: Int(FRAME_SIZE * CHANNELS * /*sizeof(opus_int16)*/2))
			let samples = pcmData.withUnsafeMutableBytes({ (_ pcm: UnsafeMutablePointer<opus_int16>) -> opus_int32 in
				return opus_decode(decoder, unsafeData, opus_int32(data.count), pcm, 160, 0)
			})

			pcmData.removeSubrange(pcmData.startIndex.advanced(by: Int(samples))...)
			return pcmData
		}

		return result!
	}
}
