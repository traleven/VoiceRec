//
//  ProfileDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 08.06.21.
//

import UIKit

class ProfileDirector: DefaultDirector {
}

extension ProfileDirector: ProfileViewFlowDelegate {

	func editUserProfile(_ user: Model.User, _ refresh: ModelRefreshHandler?) {

		let director = ProfileEditorDirector(router: router)
		let viewController = director.makeViewController(user: user) { [weak self] (result: Model.User?) in
			if let result = result {
				result.save()
				refresh?(result)
			}
			self?.router.pop(animated: true)
		}

		router.push(viewController, onDismiss: nil)
	}
}

extension ProfileDirector: ProfileViewControlDelegate {
	
	func selectProficiency(_ user: Model.User, language: Language, _ refresh: ModelRefreshHandler?) {
		
		let director = ProficiencySelectionDirector(router: router)
		let viewController = director.makeViewController(current: nil, confirm: { (result: String) in
			var newUser = user
			newUser[language] = result
			newUser.save()

			self.router.dismiss(animated: true, completion: {
				refresh?(newUser)
			})
		})
		router.present(viewController, onDismiss: nil)
	}


	func selectRepetitionPattern(_ user: Model.User, _ refresh: ModelRefreshHandler?) {

		let director = PatternSelectionDirector(router: router)
		let viewController = director.makeViewController(current: user.sequence, confirm: { (result: Shape) in
			var newUser = user
			newUser.sequence = result
			newUser.save()

			self.router.dismiss(animated: true, completion: {
				refresh?(newUser)
			})
		})
		router.present(viewController, onDismiss: nil)
	}


	func setBaseLanguage(_ user: Model.User, language: Language, _ refresh: ModelRefreshHandler?) {
		var user = user
		if user.target == language { user.target = user.base }
		user.base = language
		user.save()
		refresh?(user)
	}


	func setTargetLanguage(_ user: Model.User, language: Language, _ refresh: ModelRefreshHandler?) {
		var user = user
		if user.base == language { user.base = user.target }
		user.target = language
		user.save()
		refresh?(user)
	}

	
	func deleteLanguage(_ user: Model.User, language: Language, _ refresh: ModelRefreshHandler?) {
		var user = user
		user.remove(language: language)
		user.save()
		refresh?(user)
	}
}
