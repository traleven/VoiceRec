//
//  InboxSearchViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 17.06.21.
//

import UIKit

protocol InboxSearchViewFlowDelegate : Director {
	typealias RefreshHandle = (URL) -> Void
	typealias ApplyHandler = (Model.Egg?) -> Void

	func openInboxFolder(url: URL, onApply: ApplyHandler?)
}


protocol InboxSearchViewControlDelegate : InboxSearchViewFlowDelegate {

	func playAudioEgg(_ url: URL, progress: PlayerProgressCallback?, finish: PlayerResultCallback?)
	func stopAllAudio()
	func readTextEgg(_ egg: Model.Egg, _ refreshHandle: @escaping () -> Void)
	func delete(_ url: URL)
}


class InboxSearchViewController : NoodlesViewController, FlowControlable {
	typealias ApplyHandler = (Model.Egg?) -> Void
	
	internal var flowDelegate: InboxSearchViewControlDelegate!
	private var onApply: ApplyHandler?

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
		fatalError("Instantiating `InboxSearchViewController from storyboard is not supported")
	}


	init?(coder: NSCoder, flow: InboxSearchViewControlDelegate, id: URL, onApply: ApplyHandler?) {
		self.flowDelegate = flow
		self.url = id
		self.onApply = onApply
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


	private func audioProgress(_ progress: Double, at indexPath: IndexPath) {
		
		let cell = tableView.cellForRow(at: indexPath) as? InboxAudioCell
		cell?.progressView.progress = CGFloat(progress)
	}
}


extension InboxSearchViewController : UITableViewDataSource {

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


extension InboxSearchViewController : UITableViewDelegate {

	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

		let target = Model.Egg(id: self.subitems[indexPath.row])
		if target.type != .audio {
			return nil
		}

		var actions: [UIContextualAction] = []
		actions.addPlayAction { [unowned self] () -> Void in

			let url = self.subitems[indexPath.row]
			self.flowDelegate.playAudioEgg(url) { (progress: TimeInterval, total: TimeInterval) in
				self.audioProgress(progress / total, at: indexPath)
			} finish: { _ in
				self.audioProgress(0, at: indexPath)
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

		let egg = Model.Egg(id: subitems[indexPath.row])
		switch egg.type {
		case .directory:
			flowDelegate.openInboxFolder(url: subitems[indexPath.row], onApply: onApply)
		default:
			onApply?(egg)
		}
	}
}
