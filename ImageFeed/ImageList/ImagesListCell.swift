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

	public func configure(imageUrl: URL, for row: Int) {
		cellImage.kf.indicatorType = .activity
		cellImage.kf.setImage(with: imageUrl)
		dateLabel.text = dateFormatter.string(from: Date())
		let isLiked = row % 2 == 0
		let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
		likeButton.setImage(likeImage, for: .normal)
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cellImage.kf.cancelDownloadTask()
	}
}
