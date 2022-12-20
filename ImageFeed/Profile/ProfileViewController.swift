//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 09/10/2022.
//

import UIKit

class ProfileViewController: UIViewController {
	private let profileService = ProfileService.shared
	private var profileImageServiceObserver: NSObjectProtocol?

	private let userProfileImage: UIImageView = {
		let imageView = UIImageView(image: UIImage.asset(ImageAsset.userPick))

		imageView.clipsToBounds = true
		imageView.layer.cornerRadius = 35
		imageView.contentMode = .scaleAspectFit

		return imageView
	}()

	private let logoutButton: UIButton = {
		let button = UIButton()

		button.tintColor = .red
		button.setImage(UIImage.asset(ImageAsset.exitProfileButton), for: .normal)
		return button
	}()

	private let profileNameLabel: UILabel = {
		let label = UILabel()

		label.text = "Екатерина новикова"
		label.textColor = UIColor.asset(ColorAsset.ypWhite)
		label.font =  UIFont.asset(FontAsset.ysDisplayRegular, size: 23)
		return label
	}()

	private let loginNameLabel: UILabel = {
		let label = UILabel()

		label.text = "@ekaterina_nov"
		label.textColor = UIColor.asset(ColorAsset.ypGray)
		label.font = UIFont.asset(FontAsset.ysDisplayRegular, size: 13)
		return label
	}()

	private let descriptionLabel: UILabel = {
		let label = UILabel()

		label.text = "Hello World"
		label.textColor = UIColor.asset(ColorAsset.ypWhite)
		label.font = UIFont.asset(FontAsset.ysDisplayRegular, size: 13)
		return label
	}()



	override func viewDidLoad() {
		super.viewDidLoad()
		layoutComponents()
		updateProfileDetails(profile: profileService.profile)
	}
}


// MARK: - Notification
extension ProfileViewController {
	private func observeAvatarChanges() {
		profileImageServiceObserver = NotificationCenter.default
					.addObserver(
						forName: ProfileImageService.DidChangeNotification,
						object: nil,
						queue: .main
					) { [weak self] _ in
						guard let self = self else { return }
						self.updateAvatar()
					}
				updateAvatar()
	}

	private func updateAvatar() {
		 guard
			 let profileImageURL = ProfileImageService.shared.avatarURL,
			 let url = URL(string: profileImageURL)
		 else { return }
		 // TODO [Sprint 11] Обновить аватар, используя Kingfisher
	 }
}


extension ProfileViewController {
	private func layoutComponents() {
		view.backgroundColor = .asset(.Black)

		let vStack = UIStackView()

		vStack.axis = .vertical
		vStack.spacing = 8
		vStack.alignment = .leading
		vStack.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(vStack)


		let hStack = UIStackView()

		hStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
		hStack.isLayoutMarginsRelativeArrangement = true
		hStack.axis = .horizontal
		hStack.distribution = .equalSpacing
		hStack.alignment = .center
		hStack.translatesAutoresizingMaskIntoConstraints = false

		hStack.addArrangedSubview(userProfileImage)
		hStack.addArrangedSubview(logoutButton)

		vStack.addArrangedSubview(hStack)
		vStack.addArrangedSubview(profileNameLabel)
		vStack.addArrangedSubview(loginNameLabel)
		vStack.addArrangedSubview(descriptionLabel)




		NSLayoutConstraint.activate([
			vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
			vStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			vStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			hStack.widthAnchor.constraint(equalTo: vStack.widthAnchor),
			userProfileImage.widthAnchor.constraint(equalToConstant: 70),
			userProfileImage.heightAnchor.constraint(equalTo: userProfileImage.widthAnchor),		])
	}
}

// MARK: - Update Profile data
extension ProfileViewController {

	private func updateProfileDetails(profile: Profile?) {
		guard let profile = profile else { return }
		loginNameLabel.text = profile.login
		profileNameLabel.text = profile.name
		descriptionLabel.text = profile.bio
	}
}
