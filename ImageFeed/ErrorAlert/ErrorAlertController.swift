//
//  File.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 08/01/2023.
//

import UIKit

final class ErrorAlertViewController {
	func displayAlert(
	 over viewController: UIViewController,
	 title: String,
	 message: String?,
	 actionTitle: String,
	 onDismiss: @escaping () -> Void
 ) {
	 let alert = UIAlertController(
		 title: title,
		 message: message,
		 preferredStyle: .alert
	 )

	 let dismissAction = UIAlertAction(
		 title: actionTitle,
		 style: .default
	 ) { _ in
		 onDismiss()
	 }
	 alert.addAction(dismissAction)

	 viewController.present(alert, animated: true)
 }
}
