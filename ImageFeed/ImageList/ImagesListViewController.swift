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
			viewController.image = photos[indexPath.row].thumbImageURL
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

		imageListCell.configure(imageUrl: photos[indexPath.row].thumbImageURL, for: indexPath.row)
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
				tableView.insertRows(at: indexPaths, with: .automatic)
			} completion: { _ in }
		}
	}

}
