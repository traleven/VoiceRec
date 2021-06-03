//
//  LessonMusicViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 31.05.21.
//

import UIKit

protocol LessonMusicViewFlowDelegate: Director {

	func openPhrases(_ lesson: Model.Recipe)
	func openExport(_ lesson: Model.Recipe)
}

protocol LessonMusicViewControlDelegate: LessonMusicViewFlowDelegate {
	typealias ModelRefreshHandle = (Model.Recipe) -> Void

	func selectMusic(_ url: URL, for lesson: Model.Recipe, _ refresh: ModelRefreshHandle)
	func playMusic(_ url: URL, progress: ((TimeInterval, TimeInterval) -> Void)?, finish: ((Bool) -> Void)?)
	func stopMusic()
	func play(_ phrase: Model.Phrase, progress: ((TimeInterval, TimeInterval) -> Void)?, finish: ((Bool) -> Void)?)
	func stop(_ phrase: Model.Phrase)
	func stopAllAudio()

	func save(_ lesson: Model.Recipe)
}

class LessonMusicViewController: NoodlesViewController {
	typealias ApplyHandle = (Model.Recipe) -> Void

	private var flowDelegate: LessonMusicViewControlDelegate!
	private var onApply: ApplyHandle?

	private var lesson: Model.Recipe
	private var items: [URL]
	private var phrase: Model.Phrase?
	private var nowPlaying: Model.Broth?

	private static let defaultArtist = "Unknown artist"

	@IBOutlet var nameField: UITextField!
	@IBOutlet var tableView: UITableView!

	@IBOutlet var phraseCount: UILabel?
	@IBOutlet var durationLabel: UILabel?

	@IBOutlet var nowPlayingPanel: UIView?
	@IBOutlet var nowPlayingTitle: UILabel?
	@IBOutlet var nowPlayingArtist: UILabel?
	@IBOutlet var nowPlayingProgress: UIProgressView?
	@IBOutlet var nowPlayngPlayed: UILabel?
	@IBOutlet var nowPlayingLeft: UILabel?

	@IBOutlet var previewPhraseLabel: UILabel?

	override func viewWillAppear(_ animated: Bool) {
		refresh()
		setupNowPlaying(lesson.music ?? items.first)

		super.viewWillAppear(animated)
	}


	override func viewWillDisappearOrMinimize() {

		flowDelegate.save(lesson)
		flowDelegate.stopAllAudio()
	}


	override func viewWillDisappear(_ animated: Bool) {

		onApply?(lesson)
		super.viewWillDisappear(animated)
	}


	override func willMove(toParent parent: UIViewController?) {
		if (parent == nil) {
			flowDelegate.willDismiss(self)
		}
		super.willMove(toParent: parent)
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	init?(coder: NSCoder, flow: LessonMusicViewControlDelegate, lesson: Model.Recipe, confirm: ApplyHandle?) {

		self.flowDelegate = flow
		self.lesson = lesson
		self.onApply = confirm

		items = FileUtils.relativeContentsOfDirectory(FileUtils.getDirectory(.music))

		super.init(coder: coder)
	}


	private func refresh() {

		nameField.text = lesson.name
		phraseCount?.text = "\(lesson.phraseCount) phrases"
		durationLabel?.text = "00:00"
		tableView.reloadData()
		if phrase == nil && lesson.phraseCount > 0 {
			phrase = Model.Phrase(id: lesson[0])
		}
		if let phrase = phrase {
			previewPhraseLabel?.text = phrase.name
		}
	}


	private func refresh(_ lesson: Model.Recipe) {

		self.lesson = lesson
		refresh()
	}


	private func setupNowPlaying(_ url: URL?) {
		guard let url = url else { return }

		nowPlaying = Model.Broth(id: url)
		if let nowPlaying = nowPlaying {
			setupNowPlaying(nowPlaying)
		}
	}


	private func setupNowPlaying(_ broth: Model.Broth) {

		broth.loadAsyncTitle({ self.nowPlayingTitle?.text = $0 })
		broth.loadAsyncArtist({ self.nowPlayingArtist?.text = $0 ?? Self.defaultArtist })
		broth.loadAsyncDuration({ self.progressNowPlaying(progress: 0, total: $0) })
		self.flowDelegate.playMusic(broth.audioFile, progress: progressNowPlaying(progress:total:), finish: nil)
	}


	private func progressNowPlaying(progress: TimeInterval, total: TimeInterval) {

		self.nowPlayingLeft?.text = "-\(progress.toMinutesTimeString())"
		self.nowPlayngPlayed?.text = (total - progress).toMinutesTimeString()
		self.nowPlayingProgress?.progress = Float(progress / total)
	}


	@IBAction func previewPhrase() {

		if let phrase = phrase {
			flowDelegate.play(phrase, progress: nil, finish: nil)
		}
	}


	@IBAction func prevPhrase() {

		guard lesson.phraseCount > 0 else { return }
		guard let phrase = phrase else {
			self.phrase = Model.Phrase(id: lesson[0])
			refresh()
			return
		}
		let idx = lesson.firstIndex(of: phrase.id) ?? 1
		let newIdx = lesson.index(before: idx)
		self.phrase = Model.Phrase(id: lesson[newIdx])
		refresh()
	}


	@IBAction func nextPhrase() {

		guard lesson.phraseCount > 0 else { return }
		guard let phrase = phrase else {
			self.phrase = Model.Phrase(id: lesson[0])
			refresh()
			return
		}
		let idx = lesson.firstIndex(of: phrase.id) ?? -1
		let newIdx = lesson.index(after: idx)
		self.phrase = Model.Phrase(id: lesson[newIdx])
		refresh()
	}


	@IBAction func stopNowPlaying() {

		flowDelegate.stopMusic()
	}


	@IBAction func goToPhrases() {

		flowDelegate.openPhrases(lesson)
	}


	@IBAction func goToExport() {

		flowDelegate.openExport(lesson)
	}
}

extension LessonMusicViewController : UITableViewDataSource {

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
		cell?.accessoryType = url == lesson.music ? .checkmark : .none
		cell?.prepare(for: url)
		return cell!
	}


	private func getCellIdentifier(for phrase: URL) -> String {

		return phrase.pathExtension.isEmpty ? "music.folder" : "music.item"
	}


	func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
}


extension LessonMusicViewController : UITableViewDelegate {

	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

		let url = self.items[indexPath.row]
		let playAction = UIContextualAction(style: .normal, title: "Play", handler: { [self] (action: UIContextualAction, view: UIView, handler: @escaping (Bool) -> Void) in

				self.setupNowPlaying(url)
				handler(true)
			})
		playAction.backgroundColor = .systemGreen
		let configuration = UISwipeActionsConfiguration(actions: [playAction])
		configuration.performsFirstActionWithFullSwipe = true
		return configuration
	}


	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		let broth = items[indexPath.row]
		flowDelegate.selectMusic(broth, for: lesson, refresh(_:))
	}
}
