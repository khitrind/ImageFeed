//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 11/01/2023.
//

import Foundation

final class ImageListService {
	static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange");
	static let shared = ImageListService()

	private (set) var photos: [Photo] = []
	private var task: URLSessionTask?
	private let networkClient = NetworkRouting()

	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		return formatter
	}()




	private var lastLoadedPage: Int = 0

	private func parsePhotoResult(from result: PhotoResult) -> Photo {
		Photo(
			id: result.id,
			size: CGSize(width: result.width, height: result.height),
			createdAt: dateFormatter.date(from: result.createdAt) ?? Date(),
			welcomeDescription: result.description,
			thumbImageURL: result.urls.thumb,
			largeImageURL: result.urls.full,
			isLiked: result.isLiked
		)
	}
}


//MARK: - FetchPhoto
extension ImageListService {
	func fetchPhotosNextPage() {
		if task != nil { return }
		guard let url = getNextPhotosURL() else {
			fatalError("Unable to build next photo URL")
		}

		task = networkClient.fetch(requestType: .url(url: url)) { [weak self] (result: Result<[PhotoResult], Error>) in
			guard let self = self else { return }
			switch result {
				case .success(let photos):
					self.updateLastLoadPage()
					self.preparePhotoResult(data: photos)
				case .failure(let error):
					print(error)
			}
			self.task = nil
		}
	}

	private func getNextPhotosURL() -> URL? {
		guard let url = URL(string: photoUrl) else { return nil }

		var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
		let nextPage = lastLoadedPage + 1

		let queryItems = [URLQueryItem(name: "page", value:  "\(nextPage)"),
						  URLQueryItem(name: "per_page", value: "10")]

		urlComponents?.queryItems = queryItems

		return urlComponents?.url
	}

	private func preparePhotoResult(data: [PhotoResult]) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.photos.append(contentsOf: data.map {item in self.parsePhotoResult(from: item)})
		}


		NotificationCenter.default
			.post(
				name: ImageListService.DidChangeNotification,
				object: self
			)
	}

	private func updateLastLoadPage() {
		lastLoadedPage = lastLoadedPage + 1
	}
}


//MARK: - LikesService
extension ImageListService {
	func changeLike(photoId: String, isLiked: Bool, photoIdx: Int, _ completion: @escaping (Result<Photo, Error>) -> Void) {
		if task != nil { return }

		guard let url = URL(string: "\(photoUrl)/\(photoId)/like") else {
			fatalError("Empty url")
		}

		var request = URLRequest(url: url)
		request.httpMethod = isLiked ? "POST" : "DELETE"

		task = networkClient.fetch(requestType: .urlRequest(urlRequest: request)) { [weak self] (result: Result<PhotoResult, Error>) in
			guard let self = self else { return }
			switch result {
				case .success(let photoResult):
					self.photos[photoIdx].isLiked = isLiked
					completion(.success(self.parsePhotoResult(from: photoResult)))
				case .failure(let error):
					completion(.failure(error))

			}
			self.task = nil
		}
	}
}
