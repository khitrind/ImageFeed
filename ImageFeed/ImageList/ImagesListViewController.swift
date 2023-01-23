//
//  ViewController.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 22/09/2022.
//

import UIKit

class ImagesListViewController: UIViewController {
	private let singleViewIdentifier = "ShowSingleImageView"
	private let imageListService = ImageListService.shared
	private var imageListServiceObserver: NSObjectProtocol?
	var photos: [Photo] = []

	@IBOutlet private var tableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()
		observeImagesLoad()
		imageListService.fetchPhotosNextPage()

	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == singleViewIdentifier {
			let viewController = segue.destination as! SingleImageViewController
			let indexPath = sender as! IndexPath
			viewController.image = photos[indexPath.row].largeImageURL
		} else {
			super.prepare(for: segue, sender: sender)
		}
	}
}

extension ImagesListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return photos.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

		guard let imageListCell = cell as? ImagesListCell else {
			return UITableViewCell()
		}
		imageListCell.delegate = self

		imageListCell.configure(from: photos[indexPath.row])
		return imageListCell
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row == photos.count - 1 {
			imageListService.fetchPhotosNextPage()
		}

	}
}

extension ImagesListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: singleViewIdentifier, sender: indexPath)
	}
}

// MARK: - Udate rows at TableView
extension ImagesListViewController {
	private func observeImagesLoad() {
		imageListServiceObserver = NotificationCenter.default
					.addObserver(
						forName: ImageListService.DidChangeNotification,
						object: nil,
						queue: .main
					) { [weak self] _ in
						guard let self = self else { return }
						self.updateTableViewAnimated()
					}
	}

	func updateTableViewAnimated() {
		let oldCount = photos.count
		let newCount = imageListService.photos.count
		photos = imageListService.photos
		if oldCount != newCount {
			tableView.performBatchUpdates {
				let indexPaths = (oldCount..<newCount).map { i in
					IndexPath(row: i, section: 0)
				}
				tableView.insertRows(at: indexPaths, with: .bottom)
			} completion: { _ in }
		}
	}

}


// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
	func imageListCellDidTapLike(_ cell: ImagesListCell) {
		guard let indexPath = tableView.indexPath(for: cell) else { return }

		let photo = photos[indexPath.row]
		UIBlockingProgressHUD.show()
		
		imageListService.changeLike(photoId: photo.id, shouldLike: !photo.isLiked, photoIdx: indexPath.row) { [weak cell, self] response in
			guard let cell = cell else { return }

			switch response {
			case .success(let photoResult):
					DispatchQueue.main.async {
						self.photos[indexPath.row].isLiked = photoResult.isLiked
						cell.setIsLiked(isLiked: photoResult.isLiked)
					}
			case .failure(let error):
					print(error)
			}
			UIBlockingProgressHUD.dismiss()
		}
	}
}

