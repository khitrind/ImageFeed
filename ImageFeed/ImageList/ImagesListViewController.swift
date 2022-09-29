//
//  ViewController.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 22/09/2022.
//

import UIKit

class ImagesListViewController: UIViewController {
	private var photosName = Array(0..<20).map{ "\($0)" }

	private lazy var dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		return formatter
	}()

	@IBOutlet private var tableView: UITableView!

	func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
		guard let image = UIImage(named: photosName[indexPath.row]) else {
			return
		}

		cell.cellImage.image = image
		cell.dateLabel.text = dateFormatter.string(from: Date())
		let isLiked = indexPath.row % 2 == 0
		let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
		cell.likeButton.setImage(likeImage, for: .normal)
	}
}

extension ImagesListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return photosName.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

		guard let imageListCell = cell as? ImagesListCell else {
			return UITableViewCell()
		}

		configCell(for: imageListCell, with: indexPath)
		return imageListCell
	}
}

extension ImagesListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}
