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

	private let networkClient = NetworkRouting()

	func fetchProfileImageURL(username: String, _ completion: @escaping (Result<Void, Error>) -> Void) {
		task?.cancel()

		if let request = buildRequest(username: username) {
			task = networkClient.fetch(request: request) { [weak self] (result: Result<UserProfile, Error>) in
				guard let self = self else { return }
				switch result {
					case .success(let userProfile):
						print(userProfile)
						if let image = userProfile.profileImage?.image {
							self.avatarURL = image
						}
						completion(.success(()))
					case .failure(let error):
						completion(.failure(error))
						print(error)
				}
			}
		}
	}

	private func buildRequest(username: String) -> URLRequest? {
		if let urlComponents = URLComponents(string: "\(ProfileImageURL)/\(username)") {
			return URLRequest(url: urlComponents.url!)
		}
		return nil
	}
}
