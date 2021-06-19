//
//  InboxCell.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 06.05.21.
//

import UIKit

class InboxCell : UITableViewCell {

	var index: IndexPath?

	@IBOutlet var label : UILabel!
	@IBOutlet var place : UILabel!

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}


	override func prepareForReuse() {
		super.prepareForReuse()
	}


	func prepare(for egg: Model.Egg, at index: IndexPath) {
		self.index = index
		label?.text = egg.name
		place?.text = ""
	}
}

class InboxAudioCell : InboxCell {

	@IBOutlet var duration : UILabel!
	@IBOutlet var progressView : GradientHorizontalProgressBar!

	override func prepare(for egg: Model.Egg, at index: IndexPath) {
		super.prepare(for: egg, at: index)

		duration.text = "00:00"
		progressView.progress = 0;
		egg.loadAsyncDuration { [weak self] (totalSeconds: Double) in
			let minutes = Int(totalSeconds / 60)
			let seconds = Int(totalSeconds) - 60 * minutes
			self?.duration?.text = String(format: "%02d:%02d", minutes, seconds)
		}
		egg.loadAsyncLocation { [weak self] in
			self?.place?.text = $0
		}
	}
}

class InboxTextCell: InboxCell {
	override func prepare(for egg: Model.Egg, at index: IndexPath) {
		super.prepare(for: egg, at: index)
	}
}

class InboxFolderCell: InboxCell {

	@IBOutlet var duration : UILabel!

	override func prepare(for egg: Model.Egg, at index: IndexPath) {
		super.prepare(for: egg, at: index)

		duration.text = ""
	}
}
