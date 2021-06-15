//
//  ProficiencySelectionViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 15.06.21.
//

import UIKit

class ProficiencySelectionViewController: NoodlesViewController {

	let preselected: String?
	let onApply: ((String) -> Void)?

	@IBOutlet var picker: UIPickerView!

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	init?(coder: NSCoder, preselected: String?, confirm: ((String) -> Void)?) {

		self.onApply = confirm
		self.preselected = preselected

		super.init(coder: coder)
	}


	override func viewDidLoad() {
		super.viewDidLoad()

		picker.dataSource = DB.proficiencies
		picker.delegate = DB.proficiencies
		if let preselected = preselected {
			let preselected = DB.proficiencies.firstIndex(of: preselected)
			picker.selectRow(preselected ?? 0, inComponent: 0, animated: true)
		}
	}


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}


	@IBAction func confirm(_ sender: UIControl?) {

		let result = DB.proficiencies[picker.selectedRow(inComponent: 0)]
		onApply?(result)
	}
}
