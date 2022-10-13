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
			setImage()
		}
	}

	@IBOutlet private weak var singleImage: UIImageView!
	@IBOutlet private weak var scrollView: UIScrollView!

	@IBAction func didTapBackButton() {
		dismiss(animated: true)
	}

	@IBAction func didClickShareButton() {
		let share = UIActivityViewController(
			activityItems: [image],
			applicationActivities: nil
		)
		present(share, animated: true, completion: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setImage()
	}

	private func setImage() {
		singleImage.image = image
		rescaleScrollViewForPerfectView(image: image)
		scrollView.minimumZoomScale = 0.1
		scrollView.maximumZoomScale = 1.25
	}


	private func rescaleScrollViewForPerfectView(image: UIImage) {
		let containerSize = view.bounds.size
		let imageSize = image.size
		let hScale = containerSize.width / imageSize.width
		let vScale = containerSize.height / imageSize.height
		var scale = max(hScale, vScale)
		let minZoomScale = scrollView.minimumZoomScale
		let maxZoomScale = scrollView.maximumZoomScale
		scale = min(maxZoomScale, max(minZoomScale, scale))

		scrollView.setZoomScale(scale, animated: false)
		scrollView.layoutIfNeeded()
		let expectedContentSize = self.scrollView.contentSize

		UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
			let x = (expectedContentSize.width - containerSize.width) / 2
			let y = (expectedContentSize.height - containerSize.height) / 2
			self.scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
		} completion: { _ in }
	}
}

extension SingleImageViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		singleImage
	}

	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		guard let image = singleImage.image else { return }

		let imgViewSize = singleImage.frame.size;
		let imageSize = image.size

		var realImgSize: CGSize;

		// Считаем реальные размеры картинки
		if imageSize.width / imageSize.height > imgViewSize.width / imgViewSize.height {
			realImgSize = CGSizeMake(imgViewSize.width, imgViewSize.width / imageSize.width * imageSize.height);
		}
		else {
			realImgSize = CGSizeMake(imgViewSize.height / imageSize.height * imageSize.width, imgViewSize.height);
		}

		var fr = CGRectMake(0, 0, 0, 0);
		fr.size = realImgSize;
		// Выставляем для вьюхи реальные размеры
		singleImage.frame = fr;

		let scrollViewSize = scrollView.frame.size;

		// Считаем и выставляем офсеты со всех сторон что бы отцентровать картинку в scrollView
		let offx = (scrollViewSize.width > realImgSize.width ? (scrollViewSize.width - realImgSize.width) / 2 : 0);
		let offy = (scrollViewSize.height > realImgSize.height ? (scrollViewSize.height - realImgSize.height) / 2 : 0);

		scrollView.contentInset = UIEdgeInsets(top: offy, left: offx, bottom: offy, right: offx);
	}
}
