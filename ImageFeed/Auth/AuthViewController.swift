//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 13/11/2022.
//

import UIKit

class AuthViewController: UIViewController {
	private let webViewIdentifier = "ShowWebView"

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == webViewIdentifier {
			guard
				let webViewViewController = segue.destination as? WebViewViewController
			else { fatalError("Failed to prepare for \(webViewIdentifier)") }
			webViewViewController.delegate = self
		} else {
			super.prepare(for: segue, sender: sender)
		}
	}

}

extension AuthViewController: WebViewViewControllerDelegate {
	func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
		// TODO
	}

	func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
		dismiss(animated: true)
	}
}
