//
//  MusicCell.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 02.06.21.
//

import UIKit

class MusicCell : UITableViewCell {

	var index: IndexPath?

	@IBOutlet var label : UILabel!

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}


	override func prepareForReuse() {
		super.prepareForReuse()
	}


	func prepare(for broth: URL) {
	}
}

class MusicAudioCell : MusicCell {

	@IBOutlet var duration : UILabel!
	@IBOutlet var author : UILabel!

	override func prepare(for url: URL) {
		super.prepare(for: url)

		let broth = Model.Broth(id: url)
		let defaultTitle = broth.id.deletingPathExtension().lastPathComponent
		label.text = defaultTitle
		broth.loadAsyncTitle { [weak self] (title: String?) in
			self?.label.text = title ?? defaultTitle
		}
		let defaultArtist = "Unknown artist"
		author.text = defaultArtist
		broth.loadAsyncArtist { [weak self] (artist: String?) in
			self?.author.text = artist ?? defaultArtist
		}
		duration.text = "00:00"
		broth.loadAsyncDuration { [weak self] (totalSeconds: TimeInterval) in
			let minutes = Int(totalSeconds / 60)
			let seconds = Int(totalSeconds) - 60 * minutes
			self?.duration?.text = String(format: "%02d:%02d", minutes, seconds)
		}
	}
}

class MusicFolderCell: MusicCell {

	@IBOutlet var tracksCount : UILabel!

	override func prepare(for url: URL) {
		super.prepare(for: url)

		label.text = url.deletingPathExtension().lastPathComponent
		tracksCount.text = "\(0) tracks"
	}
}
