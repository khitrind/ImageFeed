//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 13/11/2022.
//

import UIKit

final class AuthViewController: UIViewController {
	private let webViewIdentifier = "ShowWebView"
	private let oAuth2Service = OAuth2Service()

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
		oAuth2Service.fetchAuthToken(code) { result in
			print(result)
		}
	}

	func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
		dismiss(animated: true)
	}
}
