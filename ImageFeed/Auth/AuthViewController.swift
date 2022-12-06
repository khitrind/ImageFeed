//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 13/11/2022.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
	func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
} 

final class AuthViewController: UIViewController {
	private let webViewIdentifier = "ShowWebView"
	private let oAuth2Service = OAuth2Service()
	private var oAuth2TokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage()
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
		oAuth2Service.fetchAuthToken(code) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let token):
					self.oAuth2TokenStorage.token = token
					self.delegate?.authViewController(self, didAuthenticateWithCode: token)

			case .failure(let error):
				print(error)
			}
		}
	}

	func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
		dismiss(animated: true)
	}
}
