//
//  PatternSelectionDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 05.06.21.
//

import UIKit

class PatternSelectionDirector: DefaultDirector {

	func makeViewController(current: Shape?, confirm: ((Shape) -> Void)?) -> UIViewController {
		let storyboard = getStoryboard(name: "Service", bundle: nil)
		let viewController = storyboard.instantiateViewController(identifier: "service.patternSelector", creator: { (coder: NSCoder) -> PatternSelectionViewController? in
			return PatternSelectionViewController(coder: coder, preselected: current, confirm: confirm)
		})
		return viewController
	}
}

class LanguageSelectionDirector: DefaultDirector {

	func makeViewController(current: Language?, confirm: ((Language) -> Void)?) -> UIViewController {
		let storyboard = getStoryboard(name: "Service", bundle: nil)
		let viewController = storyboard.instantiateViewController(identifier: "service.languageSelector", creator: { (coder: NSCoder) -> LanguageSelectionViewController? in
			return LanguageSelectionViewController(coder: coder, preselected: current, confirm: confirm)
		})
		return viewController
	}
}

class ProficiencySelectionDirector: DefaultDirector {

	func makeViewController(current: String?, confirm: ((String) -> Void)?) -> UIViewController {
		let storyboard = getStoryboard(name: "Service", bundle: nil)
		let viewController = storyboard.instantiateViewController(identifier: "service.proficiencySelector", creator: { (coder: NSCoder) -> ProficiencySelectionViewController? in
			return ProficiencySelectionViewController(coder: coder, preselected: current, confirm: confirm)
		})
		return viewController
	}
}

extension StringDB: UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {

		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

		return self.data.count
	}
}

extension StringDB: UIPickerViewDelegate {

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self[row]
	}
}

extension LanguageDB: UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {

		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

		return self.data.count
	}
}

extension LanguageDB: UIPickerViewDelegate {

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		let language = self[row]
		return "\(language.flag) \(language.name)"
	}
}
