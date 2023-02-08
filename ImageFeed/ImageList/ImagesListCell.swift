//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 28/09/2022.
//

import UIKit

protocol ImagesListCellDelegate: AnyObject {
	func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
	static let reuseIdentifier = "ImagesListCell"
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var cellImage: UIImageView!
	@IBOutlet weak var likeButton: UIButton!

	weak var delegate: ImagesListCellDelegate?

	@IBAction private func likeButtonClicked() {
		delegate?.imageListCellDidTapLike(self)
	}

	public func configure(from photo: Photo) {
		cellImage.kf.indicatorType = .activity
		cellImage.kf.setImage(with: photo.thumbImageURL)
		dateLabel.text = DateFormatter().displayFormat.string(from: photo.createdAt)
		setIsLiked(isLiked: photo.isLiked)
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cellImage.kf.cancelDownloadTask()
	}

	public func setIsLiked(isLiked: Bool) {
		let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
		likeButton.setImage(likeImage, for: .normal)
	}
}
