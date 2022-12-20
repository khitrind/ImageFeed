//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 19/12/2022.
//

import Foundation

final class ProfileImageService {
	private(set) var avatarURL: String?
	private var task: URLSessionTask?
	static let shared = ProfileImageService()
	static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")


	private let networkClient = NetworkRouting()

	func fetchProfileImageURL(username: String, token: String?, _ completion: @escaping (Result<Void, Error>) -> Void) {
		task?.cancel()

		if let request = buildRequest(username: username, token: token) {
			task = networkClient.fetch(request: request) { [weak self] (result: Result<UserProfile, Error>) in
				guard let self = self else { return }
				switch result {
					case .success(let userProfile):
						print(userProfile)
						if let image = userProfile.profileImage?.image {
							print(image)
							self.avatarURL = image
							NotificationCenter.default
								.post(
									name: ProfileImageService.DidChangeNotification,
									object: self,
									userInfo: ["URL": image]
								)
						}
						completion(.success(()))
						
					case .failure(let error):
						completion(.failure(error))
						print(error)
				}
				
			}
		}
	}

	private func buildRequest(username: String, token: String?) -> URLRequest? {
		if let urlComponents = URLComponents(string: "\(ProfileImageURL)/\(username)") {
			var request = URLRequest(url: urlComponents.url!)
			if let token = token {
				request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
			}

			return request
		}
		return nil
	}
}
