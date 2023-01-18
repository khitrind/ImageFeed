//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 18/01/2023.
//

import UIKit

final class TabBarController: UITabBarController {
	override func awakeFromNib() {
		super.awakeFromNib()
		let storyboard = UIStoryboard(name: "Main", bundle: .main)

		let imagesListViewController = storyboard.instantiateViewController(
			withIdentifier: "ImagesListViewController"
		)

		let profileViewController = ProfileViewController()
		profileViewController.tabBarItem = UITabBarItem(
			title: NSLocalizedString("Profile", comment: ""),
			image: UIImage(named: "tab_profile_active"),
			selectedImage: nil
		)

	   self.viewControllers = [imagesListViewController, profileViewController]
	}
}
