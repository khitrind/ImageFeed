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

	func fetchProfile(_ token: String, completion: @escaping (Result<String, Error>) -> Void) {
		task?.cancel()

		if let request = buildRequest(authToken: token) {
			task = networkClient.fetch(request: request) { [weak self] (result: Result<Profile, Error>) in
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

	private func buildRequest(authToken token: String) -> URLRequest? {
		if let urlComponents = URLComponents(string: ProfileURL) {
			var request = URLRequest(url: urlComponents.url!)
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
			return request
		}
		return nil
	}
}
