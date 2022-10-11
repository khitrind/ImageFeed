//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 10/10/2022.
//

import UIKit

class SingleImageViewController: UIViewController {
	var image: UIImage! {
		didSet {
			guard isViewLoaded else { return }
			singleImage.image = image
		}
	}

	@IBAction func didTapBackButton() {
		dismiss(animated: true)
	}

	@IBOutlet weak var singleImage: UIImageView!

	override func viewDidLoad() {
		super.viewDidLoad()
		singleImage.image = image
	}


}
