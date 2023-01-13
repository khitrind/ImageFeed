//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 30/11/2022.
//

import UIKit

final class SplashViewController: UIViewController {
	private let profileService = ProfileService.shared
	private let profileImageService = ProfileImageService.shared

	private let oAuth2Service = OAuth2Service()
	private var oAuth2TokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage()
	private let errorAlertController = ErrorAlertViewController()

	private let showAuthIdentifier = "ShowAuthIdentifier"

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		checkAuth()
	}


	private func switchToTabBarController() {
		guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }

		let tabBarController = UIStoryboard(name: "Main", bundle: .main)
			.instantiateViewController(withIdentifier: "TabBarViewController")
		window.rootViewController = tabBarController
	}

	private func checkAuth() {
		if let token = oAuth2TokenStorage.token {
			UIBlockingProgressHUD.show()
			fetchProfile(token: token)
		} else {
			performSegue(withIdentifier: showAuthIdentifier, sender: nil)
		}
	}
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
	func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
		dismiss(animated: true) { [weak self] in
			guard let self = self else { return }
			UIBlockingProgressHUD.show()
			self.fetchOAuthToken(code)
		}
	}

	private func fetchOAuthToken(_ code: String) {
		oAuth2Service.fetchAuthToken(code) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let token):
					self.oAuth2TokenStorage.token = token
					self.fetchProfile(token: token)
			case .failure:
					UIBlockingProgressHUD.dismiss()
					self.showError()
			}
		}
	}

	private func fetchProfile(token: String) {
		profileService.fetchProfile(token) { [weak self] result in
			guard let self = self else { return }
			switch result {
				case .success(let username):
					ProfileImageService.shared.fetchProfileImageURL(username: username, token: token) { _ in }
					DispatchQueue.main.async {
						self.switchToTabBarController()
					}
				case .failure:
					self.showError()
					break
			}
			UIBlockingProgressHUD.dismiss()
		}
	}
}

// MARK: - Segue
extension SplashViewController {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == showAuthIdentifier {
			guard
				let navigationController = segue.destination as? UINavigationController,
				let viewController = navigationController.viewControllers[0] as? AuthViewController
			else { fatalError("Failed to prepare for \(showAuthIdentifier)") }

			viewController.delegate = self
		} else {
			super.prepare(for: segue, sender: sender)
		   }
	}
}

// MARK: - ErrorShowing
extension SplashViewController {
	private func showError() {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else {return }
			self.errorAlertController
				.displayAlert(
					over: self,
					title: "Error!",
					message: "Something went wrong",
					actionTitle: "OK") {
						self.checkAuth()
					}
		}
	}
}
