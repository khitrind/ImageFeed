//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 18/12/2022.
//

import Foundation

final class ProfileService {
	private var task: URLSessionTask?

	private let networkClient = NetworkRouting()

	func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
		task?.cancel()

		if let request = buildRequest(authToken: token) {
			task = networkClient.fetch(request: request, handler: completion)
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
