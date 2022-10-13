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
}
