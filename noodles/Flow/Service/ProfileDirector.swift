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
}

extension ProfileDirector: ProfileViewControlDelegate {

	func selectRepetitionPattern(_ user: Model.User, _ refresh: ((Model.User) -> Void)?) {

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


	func selectUserAvatar(_ user: Model.User, _ refresh: ((Model.User) -> Void)?) {

		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		router.present(picker, onDismiss: nil)
	}
}

extension ProfileDirector: UIImagePickerControllerDelegate {

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }

		router.dismiss(animated: true) {

			var user = Model.User.Me
			user.icon = image.resizedImage(for: CGSize(width: 200, height: 200))
			user.save()
		}
	}
}

extension ProfileDirector: UINavigationControllerDelegate {
}
