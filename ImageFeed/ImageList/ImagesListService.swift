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


	private var lastLoadedPage: Int = 0

	func fetchPhotosNextPage() {
		if task != nil { return }

		if let request = buildRequest() {
			task = networkClient.fetch(requestType: .urlRequest(urlRequest: request)) { [weak self] (result: Result<[PhotoResult], Error>) in
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
	}

	private func buildRequest() -> URLRequest? {
		guard let token = OAuth2TokenStorage().token else { return nil }
		if let url = getNextPhotosURL() {
			var request = URLRequest(url: url)
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
			return request
		}
		return nil
	}

	private func getNextPhotosURL() -> URL? {
		guard let url = URL(string: PhotoUrl) else { return nil }

		var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
		let nextPage = lastLoadedPage + 1

		let queryItems = [URLQueryItem(name: "page", value:  "\(nextPage)"),
						  URLQueryItem(name: "per_page", value: "10")]

		urlComponents?.queryItems = queryItems

		return urlComponents?.url
	}

	private func preparePhotoResult(data: [PhotoResult]) {
		self.photos.append(contentsOf: data.map {item in Photo.fromPhotoResult(from: item)})
		print(self.photos)

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
