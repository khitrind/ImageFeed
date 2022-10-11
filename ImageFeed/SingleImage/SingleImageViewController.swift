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

	@IBOutlet weak var singleImage: UIImageView!
	@IBOutlet weak var scrollView: UIScrollView!

	@IBAction func didTapBackButton() {
		dismiss(animated: true)
	}

	@IBAction func didClickShareButtom() {
		let share = UIActivityViewController(
			activityItems: [singleImage],
			applicationActivities: nil
		)
		present(share, animated: true, completion: nil)
	}


	override func viewDidLoad() {
		super.viewDidLoad()
		setImage()
		configureScrollViewScale()
	}

	private func setImage() {
		singleImage.image = image
		rescaleScrollViewForPerfectView(image: image)
	}

	private func configureScrollViewScale() {
		scrollView.minimumZoomScale = 0.1
		scrollView.maximumZoomScale = 1.25
	}

	private func rescaleScrollViewForPerfectView(image: UIImage) {
		let containerSize = view.bounds.size
		let imageSize = image.size
		let hScale = containerSize.width / imageSize.width
		let vScale = containerSize.height / imageSize.height
		let scale = max(hScale, vScale)
		let expectedContentSize = CGSize(
			width: imageSize.width * scale,
			height: imageSize.height * scale
		)
		UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
			self.scrollView.setZoomScale(scale, animated: false)
			let x = (expectedContentSize.width - containerSize.width) / 2
			let y = (expectedContentSize.height - containerSize.height) / 2
			self.scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
		} completion: { _ in
		}
	}
}


// Привет, вы не могли бы посоветовать какой-нибудь литературы про работу с картинками в IOS?
// Заранее спасибо за ответ, интересен аспект как верстать интерфейсы в которых возможно изображения,
// не известного заранее размера.
// + к сожалению так и не понял, что делать с картинкой внутри scrollView, в примерах из теории,
// она так же не растягивается на весь экран...
extension SingleImageViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		singleImage
	}
}
