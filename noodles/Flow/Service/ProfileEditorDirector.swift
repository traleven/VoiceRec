//
//  ProfileEditorDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 14.06.21.
//

import UIKit

class ProfileEditorDirector: DefaultDirector {

	func makeViewController(user: Model.User, confirm: @escaping (Model.User?) -> Void) -> UIViewController {
		let storyboard = UIStoryboard(name: "Service", bundle: nil)
		let viewController = storyboard.instantiateViewController(identifier: "service.profileEditor", creator: { (coder: NSCoder) -> ProfileEditorViewController? in
			return ProfileEditorViewController(coder: coder, flow: self, content: user, applyHandle: confirm)
		})
		return viewController
	}
}

extension ProfileEditorDirector: ProfileEditorViewFlowDelegate {
}

extension ProfileEditorDirector: ProfileEditorViewControlDelegate {
	
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


	func selectUserAvatar(_ user: Model.User, _ refresh: ModelRefreshHandler?) {

		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		router.present(picker, onDismiss: {
			refresh?(Model.User.Me)
		})
	}


	func addLanguage(_ user: Model.User, _ refresh: ModelRefreshHandler?) {

		let director = LanguageSelectionDirector(router: router)
		let viewController = director.makeViewController(current: nil, confirm: { (result: Language) in

			self.router.dismiss(animated: true, completion: {
				self.selectProficiency(user, language: result, refresh)
			})
		})
		router.present(viewController, onDismiss: nil)
	}


	func selectProficiency(_ user: Model.User, language: Language, _ refresh: ModelRefreshHandler?) {

		let director = ProficiencySelectionDirector(router: router)
		let viewController = director.makeViewController(current: user[language], confirm: { (result: String) in
			var newUser = user
			newUser[language] = result
			newUser.save()

			self.router.dismiss(animated: true, completion: {
				refresh?(newUser)
			})
		})
		router.present(viewController, onDismiss: nil)
	}


	func addTutor(_ user: Model.User, _ refresh: ModelRefreshHandler?) {
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

extension ProfileEditorDirector: UIImagePickerControllerDelegate {

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }

		var user = Model.User.Me
		user.icon = image.resizedImage(for: CGSize(width: 200, height: 200))
		user.save()

		router.dismiss(animated: true) {
		}
	}
}

extension ProfileEditorDirector: UINavigationControllerDelegate {
}
