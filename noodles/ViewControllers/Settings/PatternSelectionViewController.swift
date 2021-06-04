//
//  PatternSelectionViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 05.06.21.
//

import UIKit

class PatternSelectionViewController: NoodlesViewController {

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

		picker.dataSource = DB.presets
		picker.delegate = DB.presets
		if let preselected = preselected {
			let preselected = DB.presets.firstIndex(of: preselected)
			picker.selectRow(preselected ?? 0, inComponent: 0, animated: true)
		}
	}


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}


	@IBAction func confirm(_ sender: UIControl?) {

		if let result = DB.presets?[picker.selectedRow(inComponent: 0)] {
			onApply?(result)
		}
	}
}

extension ArrayDB: UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {

		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

		return self.data.count
	}
}

extension ArrayDB: UIPickerViewDelegate {

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self[row]
	}
}
