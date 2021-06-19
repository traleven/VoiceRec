//
//  InboxViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 10.05.21.
//

import UIKit

protocol InboxListViewFlowDelegate : Director {
	typealias RefreshHandle = (URL) -> Void

	func openInboxFolder(url: URL)
	func openMyNoodles()
}


protocol InboxListViewControlDelegate : InboxListViewFlowDelegate {
	
	func startRecording(to parent: Model.Egg?, progress: ((TimeInterval) -> Void)?, finish: ((Bool) -> Void)?)
	func stopRecording(_ refreshHandle: RefreshHandle)
	func playAudioEgg(_ url: URL, progress: PlayerProgressCallback?, finish: PlayerResultCallback?)
	func stopAllAudio()
	func addTextEgg(to parent: Model.Egg?, _ refreshHandle: @escaping RefreshHandle)
	func readTextEgg(_ egg: Model.Egg, _ refreshHandle: @escaping () -> Void)
	func delete(_ url: URL)
	func share(_ egg: Model.Egg)
	func convertToPhrase(_ egg: Model.Egg, _ refresh: (() -> Void)?)
}


class InboxListViewController : NoodlesViewController, FlowControlable {

	internal var flowDelegate: InboxListViewControlDelegate!

	private var url: URL
	private var current: Model.Egg!
	private var subitems: [URL] = []


	@IBOutlet var tableView: UITableView!
	@IBOutlet var recordingFade: UIView?
	@IBOutlet var recordingTime: UILabel?
	@IBOutlet var menuButton: UIBarButtonItem?


	override func viewDidLoad() {
		super.viewDidLoad()
	}


	override func viewWillAppear(_ animated: Bool) {
		refresh()
		if current.id != FileUtils.getDirectory(.inbox) {
			navigationItem.leftBarButtonItem = nil
		}
		
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(onAppMoveToBackground), name: UIApplication.willResignActiveNotification, object: nil)

		super.viewWillAppear(animated)
	}


	@objc private func onAppMoveToBackground() {
		flowDelegate.stopAllAudio()
	}


	override func viewWillDisappear(_ animated: Bool) {
		onAppMoveToBackground()
		let notificationCenter = NotificationCenter.default
		notificationCenter.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)

		super.viewWillDisappear(animated)
	}


	override func willMove(toParent parent: UIViewController?) {
		if (parent == nil) {
			flowDelegate.willDismiss(self)
		}
		super.willMove(toParent: parent)
	}


	required init?(coder: NSCoder) {
		self.url = FileUtils.getDirectory(.inbox)
		super.init(coder: coder)

		let router = NavigationControllerRouter(controller: self.navigationController!)
		let director = InboxDirector(router: router)
		self.flowDelegate = director
	}


	init?(coder: NSCoder, flow: InboxListViewControlDelegate, id: URL) {
		self.flowDelegate = flow
		self.url = id
		super.init(coder: coder)
	}


	private func refresh(with url: URL?) {
		self.url = url ?? FileUtils.getDirectory(.inbox)
		current = Model.Egg(id: self.url)
		subitems = current!.children
		tableView.reloadData()
		self.title = current?.name
	}


	private func refresh() {
		current = Model.Egg(id: self.url)
		subitems = current!.children
		tableView.reloadData()
		self.title = current?.name
	}


	@IBAction func recordNewAudio(sender: UIButton?) {
		recordingFade?.isHidden = false

		sender?.isSelected = true
		flowDelegate.startRecording(to: current, progress: { [weak self] (duration: TimeInterval) in
			self?.recordingTime?.text = duration.toMinutesTimeString()
		}, finish: { [weak self, weak sender] (ok: Bool) in
			self?.recordingFade?.isHidden = true
			sender?.isSelected = false
		})
	}


	@IBAction func stopRecordingAutio() {

		flowDelegate.stopRecording(refresh(with:))
	}


	@IBAction func writeNewMemo() {
		
		flowDelegate.addTextEgg(to: current, refresh(with:))
	}


	@IBAction func goToMyNoodles() {

		flowDelegate.openMyNoodles()
	}

	private func audioProgress(_ progress: Double, at indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as? InboxAudioCell
		cell?.progressView.progress = CGFloat(progress)
	}
}


extension InboxListViewController : UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return subitems.count
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let egg = Model.Egg(id: subitems[indexPath.row])
		let cellId = getCellIdentifier(for: egg)

		var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? InboxCell
		if (cell == nil) {
			cell = InboxCell()
		}
		cell?.prepare(for: egg, at: indexPath)
		return cell!
	}


	private func getCellIdentifier(for egg: Model.Egg) -> String {
		switch egg.type {
		case .audio: return "inbox.audio"
		case .directory, .inbox: return "inbox.folder"
		case .text, .json: return "inbox.text"
		default:
			return "inbox.unknown"
		}
	}


	func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
}


extension InboxListViewController : UITableViewDelegate {

	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

		let target = Model.Egg(id: self.subitems[indexPath.row])
		let type = target.type
		var actions: [UIContextualAction] = []

		if type == .audio {
			actions.addPlayAction { [unowned self] () -> Void in

				let url = self.subitems[indexPath.row]
				self.flowDelegate.playAudioEgg(url) { (progress: TimeInterval, total: TimeInterval) in
					self.audioProgress(progress / total, at: indexPath)
				} finish: { _ in
					self.audioProgress(0, at: indexPath)
				}
			}
		}
		if type == .text || type == .json {
			actions.addNormalAction(title: "Edit", accent: true) { [weak self] () -> Void in
				if let self = self {
					self.flowDelegate.readTextEgg(target, self.refresh)
				}
			}
		}
		if type == .audio || type == .text || type == .json {
			actions.addNormalAction(title: "Convert to phrase", accent: false) { [unowned self] in
				self.flowDelegate.convertToPhrase(target, { [weak self] in
					self?.refresh()
				})
			}
		}

		return makeConfiguration(fullSwipe: true, actions: actions)
	}


	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

		var actions: [UIContextualAction] = []
		actions.addDeleteAction { [unowned self] () -> Void in

			let url = self.subitems[indexPath.row]
			self.flowDelegate.delete(url)
			self.refresh()
		}

		return makeConfiguration(fullSwipe: false, actions: actions)
	}


	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		flowDelegate.openInboxFolder(url: subitems[indexPath.row])
	}
}
