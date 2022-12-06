//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 30/11/2022.
//

import UIKit

final class SplashViewController: UIViewController {
	private let oAuth2TokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage()

	private let showAuthIdentifier = "ShowAuthIdentifier"

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		checkAuth()
	}

	private func checkAuth() {
		if (oAuth2TokenStorage.token) != nil {
			switchToTabBarController()
		} else {
			performSegue(withIdentifier: showAuthIdentifier, sender: nil)
		}
	}

	private func switchToTabBarController() {
		guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }

		let tabBarController = UIStoryboard(name: "Main", bundle: .main)
			.instantiateViewController(withIdentifier: "TabBarViewController")
		window.rootViewController = tabBarController
	}
}


// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
	func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
		switchToTabBarController()
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
