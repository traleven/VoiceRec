//
//  ShareViewController.swift
//  import to inbox
//
//  Created by Ivan Dolgushin on 19.06.21.
//

import UIKit
import Social
import AudioToolbox

class ShareViewController: UIViewController {

	fileprivate let mpeg4aIdentifier = "public.mpeg-4-audio"
	fileprivate let m4aIdentifier = "com.apple.m4a-audio"
	fileprivate let oggIdentifier = "org.xiph.oga"
	fileprivate let mp3Identifier = "public.mp3"

	private var items: [(NSItemProvider, URL?)] = []
	private var inputItems: [NSExtensionItem] = []
	@IBOutlet var tableView: UITableView?

	override func viewDidLoad() {
		super.viewDidLoad()

		DispatchQueue.main.setSpecific(key: DispatchSpecificKey<Bool>(), value: true)
		guard let context = extensionContext else { return }
		let group = DispatchGroup()
		let loadCompletionHandler = { [unowned self] (item: NSItemProvider, url: URL?) -> Void in
			DispatchQueue.syncToMain {
				items.append((item, url))
			}
		}
		for item in context.inputItems as! [NSExtensionItem] {
			guard let attachments = item.attachments else { continue }

			for itemProvider in attachments {
				if loadInPlaceRepresentation(group: group, itemProvider: itemProvider, uti: m4aIdentifier, loadCompletionHandler)
					|| loadInPlaceRepresentation(group: group, itemProvider: itemProvider, uti: mpeg4aIdentifier, loadCompletionHandler)
					|| loadInPlaceRepresentation(group: group, itemProvider: itemProvider, uti: oggIdentifier, loadCompletionHandler)
					|| loadInPlaceRepresentation(group: group, itemProvider: itemProvider, uti: mp3Identifier, loadCompletionHandler) {

					inputItems.append(item)
				}
			}
		}
		group.notify(queue: .main) {
			self.tableView?.reloadData()
		}
	}


	private func loadInPlaceRepresentation(group: DispatchGroup, itemProvider: NSItemProvider, uti: String, _ completionHandler: @escaping (NSItemProvider, URL?) -> Void) -> Bool {
		guard itemProvider.hasItemConformingToTypeIdentifier(uti) else { return false }

		group.enter()
		itemProvider.loadInPlaceFileRepresentation(forTypeIdentifier: uti) { (url, inPlace, error) in
			completionHandler(itemProvider, url)
			DispatchQueue.main.async {
				group.leave()
			}
		}
		return true
	}


	@IBAction func cancel() {
		if let context = extensionContext {
			context.completeRequest(returningItems: [], completionHandler: nil)
		}
	}


	@IBAction func importToInbox() {

		let inboxRoot = FileUtils.getSharedDirectory(.inbox)
		importFiles(to: inboxRoot)
	}


    @IBAction func importMusic() {

		let musicRoot = FileUtils.getSharedDirectory(.music)
		importFiles(to: musicRoot)
    }

	
	private func importFiles(to directory: URL) {
		guard let context = extensionContext else { return }
		let group = DispatchGroup()
		for itemProvider in items {
			if loadFileRepresentation(group: group, itemProvider: itemProvider.0, uti: m4aIdentifier, {
				if let url = $0 {
					printFormatId(url)
					_ = FileUtils.copy(url, to: directory)
				}
			}) {
				continue
			}
			if loadFileRepresentation(group: group, itemProvider: itemProvider.0, uti: mpeg4aIdentifier, {
				if let url = $0 {
					printFormatId(url)
					_ = FileUtils.copy(url, to: directory)
				}
			}) {
				continue
			}
			if loadFileRepresentation(group: group, itemProvider: itemProvider.0, uti: mp3Identifier, {
				if let url = $0 {
					let group = DispatchGroup()
					group.enter()
					importAudio(mp3: url, m4a: directory.appendingPathComponent("\(UUID().uuidString).m4a"), {
						group.leave()
					})
					group.wait()
				}
			}) {
				continue
			}
			if loadFileRepresentation(group: group, itemProvider: itemProvider.0, uti: oggIdentifier, {
				if let url = $0 {
					importAudio(ogg: url, m4a: directory.appendingPathComponent("\(UUID().uuidString).m4a"), {
					})
				}
			}) {
				continue
			}
			print("Unsupported attachment format for: \(itemProvider)")
		}

		// Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
		group.notify(queue: .main) { [self] in
			context.completeRequest(returningItems: inputItems, completionHandler: nil)
		}
	}


	private func loadFileRepresentation(group: DispatchGroup, itemProvider: NSItemProvider, uti: String, _ completionHandler: @escaping (URL?) -> Void) -> Bool {
		guard itemProvider.hasItemConformingToTypeIdentifier(uti) else { return false }

		group.enter()
		itemProvider.loadFileRepresentation(forTypeIdentifier: uti) { (url, error) in
			if let error = error { print(error) }
			completionHandler(url)
			DispatchQueue.main.async {
				group.leave()
			}
		}
		return true
	}
}

fileprivate func importAudio(mp3 source: URL, m4a destination: URL, _ onComplete: (() -> Void)? = nil) {

	//printFormatId(source)
	if let converter = AVAudioFileConverter(inputFileURL: source, outputFileURL: destination) {
		converter.convert(onComplete: { _ in
			onComplete?()
		})
	}
}

fileprivate func importAudio(ogg source: URL, m4a destination: URL, _ onComplete: (() -> Void)? = nil) {

	printFormatId(source)
}

func printFormatId(_ url: URL) {
	var sourceFile : ExtAudioFileRef? = nil

	var srcFormat : AudioStreamBasicDescription = AudioStreamBasicDescription()

	let status = ExtAudioFileOpenURL(url as CFURL, &sourceFile)
	let error = NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil)
	print(error)

	var thePropertySize: UInt32 = UInt32(MemoryLayout.stride(ofValue: srcFormat))

	ExtAudioFileGetProperty(sourceFile!,
		kExtAudioFileProperty_FileDataFormat,
		&thePropertySize, &srcFormat)

	print(srcFormat)
}

func convertAudio(_ url: URL, outputURL: URL) {
	var error : OSStatus = noErr
	var destinationFile : ExtAudioFileRef? = nil
	var sourceFile : ExtAudioFileRef? = nil

	var srcFormat : AudioStreamBasicDescription = AudioStreamBasicDescription()
	var dstFormat : AudioStreamBasicDescription = AudioStreamBasicDescription()

	ExtAudioFileOpenURL(url as CFURL, &sourceFile)

	var thePropertySize: UInt32 = UInt32(MemoryLayout.stride(ofValue: srcFormat))

	ExtAudioFileGetProperty(sourceFile!,
		kExtAudioFileProperty_FileDataFormat,
		&thePropertySize, &srcFormat)

	dstFormat.mSampleRate = srcFormat.mSampleRate  //Set sample rate
	dstFormat.mFormatID = kAudioFormatMPEG4AAC
	dstFormat.mChannelsPerFrame = srcFormat.mChannelsPerFrame
	dstFormat.mBitsPerChannel = srcFormat.mBitsPerChannel
	dstFormat.mBytesPerPacket = 0//2 * dstFormat.mChannelsPerFrame
	dstFormat.mBytesPerFrame = 0//2 * dstFormat.mChannelsPerFrame
	dstFormat.mFramesPerPacket = 1
	dstFormat.mFormatFlags = 0//kLinearPCMFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger


	// Create destination file
	error = ExtAudioFileCreateWithURL(
		outputURL as CFURL,
		kAudioFormatMPEG4AAC,
		&dstFormat,
		nil,
		AudioFileFlags.eraseFile.rawValue,
		&destinationFile)
	reportError(error: error)

	error = ExtAudioFileSetProperty(sourceFile!,
			kExtAudioFileProperty_ClientDataFormat,
			thePropertySize,
			&dstFormat)
	reportError(error: error)

	error = ExtAudioFileSetProperty(destinationFile!,
									 kExtAudioFileProperty_ClientDataFormat,
									thePropertySize,
									&dstFormat)
	reportError(error: error)

	let bufferByteSize : UInt32 = 32768
	var srcBuffer = [UInt8](repeating: 0, count: 32768)
	var sourceFrameOffset : ULONG = 0

	while(true){
		var fillBufList = AudioBufferList(
			mNumberBuffers: 1,
			mBuffers: AudioBuffer(
				mNumberChannels: 2,
				mDataByteSize: UInt32(srcBuffer.count),
				mData: &srcBuffer
			)
		)
		var numFrames : UInt32 = 0

		if(dstFormat.mBytesPerFrame > 0){
			numFrames = bufferByteSize / dstFormat.mBytesPerFrame
		}

		error = ExtAudioFileRead(sourceFile!, &numFrames, &fillBufList)
		reportError(error: error)

		if(numFrames == 0){
			error = noErr;
			break;
		}

		sourceFrameOffset += numFrames
		error = ExtAudioFileWrite(destinationFile!, numFrames, &fillBufList)
		reportError(error: error)
	}

	error = ExtAudioFileDispose(destinationFile!)
	reportError(error: error)
	error = ExtAudioFileDispose(sourceFile!)
	reportError(error: error)
}

func reportError(error: OSStatus) {
	// Handle error
	print(error)
}

extension ShareViewController : UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return items.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let item = items[indexPath.row].1
		var cell = tableView.dequeueReusableCell(withIdentifier: "music.item") as? MusicCell
		if (cell == nil) {
			cell = MusicCell()
		}
		cell?.prepare(for: item!)
		return cell!
	}

}

extension ShareViewController : UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

/*
SUBQUERY(
	extensionItems,
	$extensionItem,
	SUBQUERY(
		$extensionItem.attachments,
		$attachment,
		ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "public.mpeg-4-audio"
		|| ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "com.apple.m4a-audio"
		|| ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "org.xiph.oga"
		|| ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "public.mp3"
	).@count > 0
).@count > 0
*/
