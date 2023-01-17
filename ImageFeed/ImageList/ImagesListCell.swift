//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 28/09/2022.
//

import UIKit

final class ImagesListCell: UITableViewCell {
	static let reuseIdentifier = "ImagesListCell"
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var cellImage: UIImageView!
	@IBOutlet weak var likeButton: UIButton!

	private lazy var dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		return formatter
	}()

	public func configure(from photo: Photo, for row: Int) {
		cellImage.kf.indicatorType = .activity
		cellImage.kf.setImage(with: photo.thumbImageURL)
		dateLabel.text = dateFormatter.string(from: Date())
		let likeImage = photo.isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
		likeButton.setImage(likeImage, for: .normal)
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cellImage.kf.cancelDownloadTask()
	}
}
