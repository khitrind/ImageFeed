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

	private init() {}

	func fetchProfileImageURL(username: String, _ completion: @escaping (Result<Void, Error>) -> Void) {
		task?.cancel()

		guard let url = URL(string: "\(profileImageURL)/\(username)") else {
			fatalError("Enable to build profile URL")
		}

		task = networkClient.fetch(requestType: .url(url: url)) { [weak self] (result: Result<UserProfile, Error>) in
			guard let self = self else { return }
			switch result {
				case .success(let userProfile):
					if let image = userProfile.profileImage?.image {
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
			}

		}
	}
}
