//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 30/11/2022.
//

import UIKit

final class SplashViewController: UIViewController {
	private weak var profileService = ProfileService.shared
	private weak var profileImageService = ProfileImageService.shared
	private var isAuthorized: Bool = false
	private var maxRetryCount: Int = 5

	private let oAuth2Service = OAuth2Service()
	private var oAuth2TokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage()
	private let errorAlertController = ErrorAlertViewController()

	private let showAuthIdentifier = "ShowAuthIdentifier"

	private let practicumLogoView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = .asset(.splashScreenLogo)
		imageView.tintColor = .asset(.ypWhite)
		imageView.contentMode = .scaleAspectFit

		return imageView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		layoutComponents()
	}

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
		guard isAuthorized == false else  {
			return
		}

		if oAuth2TokenStorage.token != nil {
			UIBlockingProgressHUD.show()
			fetchProfile()
		} else {
			let storyboard = UIStoryboard(name: "Main", bundle: .main)
			guard let authViewController = storyboard.instantiateViewController(
				withIdentifier: "AuthViewController"
			) as? AuthViewController else {
				return
			}
			authViewController.delegate = self
			authViewController.modalPresentationStyle = .fullScreen
			present(authViewController, animated: true)
		}
	}
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
	func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
		isAuthorized = true
		dismiss(animated: true) { [weak self] in
			guard let self = self else { return }
			UIBlockingProgressHUD.show()
			self.fetchOAuthToken(code)
		}
	}

	private func fetchOAuthToken(_ code: String) {
		oAuth2Service.fetchAuthToken(code) {  [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let token):
					self.oAuth2TokenStorage.token = token
					self.fetchProfile()
			case .failure:
					UIBlockingProgressHUD.dismiss()
					self.showError()
			}
		}
	}

	private func fetchProfile() {
		profileService?.fetchProfile { [weak self] result in
			guard let self = self else { return }
			switch result {
				case .success(let username):
					ProfileImageService.shared.fetchProfileImageURL(username: username) { _ in }
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
			let isRetryLimit =  self.maxRetryCount >= 5;
			let message = isRetryLimit ? "Все сломалось" : "Попробовать еще?"
			let actionTitle = isRetryLimit ? "ОК" : "Да"
			self.errorAlertController
				.displayAlert(
					over: self,
					title: "Error!",
					message: "Something went wrong",
					actionTitle: actionTitle) {
						if !isRetryLimit {
							self.checkAuth()
						}
					}
		}
	}
}


// MARK: - Layout
extension SplashViewController {
	private func layoutComponents() {
		view.backgroundColor = .asset(.Black)
		practicumLogoView.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(practicumLogoView)

		NSLayoutConstraint.activate([
			practicumLogoView.centerXAnchor.constraint(
				equalTo: view.centerXAnchor),
			practicumLogoView.centerYAnchor.constraint(
				equalTo: view.centerYAnchor),
			practicumLogoView.widthAnchor.constraint(
				equalTo: view.widthAnchor, multiplier: 0.2),
			practicumLogoView.heightAnchor.constraint(
				equalTo: practicumLogoView.widthAnchor)
		])
	}
}
