//
//  PatternSelectionDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 05.06.21.
//

import UIKit

class PatternSelectionDirector: DefaultDirector {

	func makeViewController(current: String?, confirm: ((String) -> Void)?) -> UIViewController {
		let storyboard = UIStoryboard(name: "Service", bundle: nil)
		let viewController = storyboard.instantiateViewController(identifier: "service.patternSelector", creator: { (coder: NSCoder) -> PatternSelectionViewController? in
			return PatternSelectionViewController(coder: coder, flow: self, preselected: current, confirm: confirm)
		})
		return viewController
	}
}

extension PatternSelectionDirector: PatternSelectionViewFlowDelegate {
}

extension PatternSelectionDirector: PatternSelectionViewControlDelegate {
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
