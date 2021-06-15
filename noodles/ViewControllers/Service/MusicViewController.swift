//
//  MusicViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 16.06.21.
//

import UIKit

protocol MusicViewFlowDelegate: Director {
	typealias RefreshHandle = () -> Void

}

protocol MusicViewControlDelegate: MusicViewFlowDelegate {
	typealias RefreshHandle = () -> Void

	func playMusic(_ url: URL, volume: Float, progress: PlayerProgressCallback?, finish: PlayerResultCallback?)
	func stopMusic()
	func stopAllAudio()
}

class MusicViewController: NoodlesViewController {

	private var flowDelegate: MusicViewControlDelegate!

	private var items: [URL] = []
	private var nowPlaying: Model.Broth?

	private static let defaultArtist = "Unknown artist"

	@IBOutlet var tableView: UITableView!

	@IBOutlet var nowPlayingPanel: UIView?
	@IBOutlet var nowPlayingTitle: UILabel?
	@IBOutlet var nowPlayingArtist: UILabel?
	@IBOutlet var nowPlayingProgress: UIProgressView?
	@IBOutlet var nowPlayngPlayed: UILabel?
	@IBOutlet var nowPlayingLeft: UILabel?

	@IBOutlet var previewPhraseLabel: UILabel?

	override func viewWillAppear(_ animated: Bool) {
		refresh()
		setupNowPlaying(items.first, autoPlay: false)

		super.viewWillAppear(animated)
	}


	override func viewWillDisappearOrMinimize() {

		flowDelegate.stopAllAudio()
	}


	override func willMove(toParent parent: UIViewController?) {
		if (parent == nil) {
			flowDelegate.willDismiss(self)
		}
		super.willMove(toParent: parent)
	}


	required init?(coder: NSCoder) {
		super.init(coder: coder)

		guard let navigationController = navigationController else {
			fatalError("Storyboard-initialized MusicViewController must have a UINavigationController parent")
		}

		let router = NavigationControllerRouter(controller: navigationController)
		self.flowDelegate = MusicDirector(router: router)

	}


	init?(coder: NSCoder, flow: MusicViewControlDelegate) {

		self.flowDelegate = flow
		super.init(coder: coder)
	}


	private func refresh() {

		items = FileUtils.relativeContentsOfDirectory(FileUtils.getDirectory(.music))
		tableView.reloadData()
	}


	private func setupNowPlaying(_ url: URL?, autoPlay: Bool = true) {
		guard let url = url else { return }

		nowPlaying = Model.Broth(id: url)
		if let nowPlaying = nowPlaying {
			setupNowPlaying(nowPlaying, autoPlay: autoPlay)
		}
	}


	private func setupNowPlaying(_ broth: Model.Broth, autoPlay: Bool = true) {

		broth.loadAsyncTitle({ self.nowPlayingTitle?.text = $0 })
		broth.loadAsyncArtist({ self.nowPlayingArtist?.text = $0 ?? Self.defaultArtist })
		broth.loadAsyncDuration({ self.progressNowPlaying(progress: 0, total: $0) })
		if autoPlay {
			self.flowDelegate.playMusic(
				broth.audioFile,
				volume: Settings.music.volume,
				progress: progressNowPlaying(progress:total:),
				finish: nil
			)
		}
	}


	private func progressNowPlaying(progress: TimeInterval, total: TimeInterval) {

		self.nowPlayingLeft?.text = "-\(progress.toMinutesTimeString())"
		self.nowPlayngPlayed?.text = (total - progress).toMinutesTimeString()
		self.nowPlayingProgress?.progress = Float(progress / total)
	}


	@IBAction func stopNowPlaying() {

		flowDelegate.stopMusic()
	}
}

extension MusicViewController : UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let url = items[indexPath.row]
		let cellId = getCellIdentifier(for: url)

		var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? MusicCell
		if (cell == nil) {
			cell = MusicCell()
		}
		cell?.prepare(for: url)
		return cell!
	}


	private func getCellIdentifier(for phrase: URL) -> String {

		return phrase.pathExtension.isEmpty ? "music.folder" : "music.item"
	}


	func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
}


extension MusicViewController : UITableViewDelegate {

	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

		let url = self.items[indexPath.row]
		var actions: [UIContextualAction] = []
		actions.addDeleteAction { [unowned self] () -> Void in
			FileUtils.delete(url)
			self.refresh()
		}

		return makeConfiguration(fullSwipe: false, actions: actions)
	}


	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		let broth = items[indexPath.row]
		setupNowPlaying(broth)
	}
}
