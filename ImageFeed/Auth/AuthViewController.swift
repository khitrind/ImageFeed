//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 13/11/2022.
//

import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
	func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
} 

final class AuthViewController: UIViewController {
	private let webViewIdentifier = "ShowWebView"
	weak var delegate: AuthViewControllerDelegate?

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == webViewIdentifier {
			guard let webViewViewController = segue.destination as? WebViewViewController
			else { fatalError("Failed to prepare for \(webViewIdentifier)") }

			webViewViewController.delegate = self
		} else {
			super.prepare(for: segue, sender: sender)
		}
	}

}

extension AuthViewController: WebViewViewControllerDelegate {
	func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
		self.delegate?.authViewController(self, didAuthenticateWithCode: code)
	}

	func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
		dismiss(animated: true)
	}
}
