//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 18/12/2022.
//

import Foundation

final class ProfileService {
	private(set) var profile: Profile?
	private var task: URLSessionTask?
	static let shared = ProfileService()

	private let networkClient = NetworkRouting()

	private init() {}

	func fetchProfile(completion: @escaping (Result<String, Error>) -> Void) {
		task?.cancel()

		guard let url = URL(string: profileURL) else {
			fatalError("Unable to build profile URL")
		}

		task = networkClient.fetch(requestType: .url(url: url)) { [weak self] (result: Result<Profile, Error>) in
			guard let self = self else { return }
			switch result {
				case .success(let profile):
					self.profile = profile
					completion(.success(profile.username))
				case .failure(let error):
					completion(.failure(error))
					print(error)
			}
		}
	}
}
