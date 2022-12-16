//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 17/11/2022.
//

import Foundation

final class OAuth2Service {
	private var lastCode: String?
	private var task: URLSessionTask?
	private let networkClient = NetworkRouting()
	private let jsonDecoder = JSONDecoder()

	func fetchAuthToken(_ code: String, handler: @escaping (Result<String, Error>) -> Void) {
		assert(Thread.isMainThread)
		if lastCode == code { return }
		task?.cancel()
		lastCode = code

		guard let request = makeRequest(code: code) else {return}

		task = networkClient.fetch(request: request) {[weak self] (response: Result<OAuthTokenResponseBody, Error>) in
			guard let self = self else {return}
			self.task = nil

			switch response {
			case .success(let data):
					handler(.success(data.accessToken))
			case .failure(let error):
					self.lastCode = nil
					handler(.failure(error))
			}
		}
	}

	private func makeRequest(code: String) -> URLRequest? {
		if var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") {
			urlComponents.queryItems = [
			   URLQueryItem(name: "client_id", value: AccessKey),
			   URLQueryItem(name: "redirect_uri", value: RedirectURI),
			   URLQueryItem(name: "code", value: code),
			   URLQueryItem(name: "client_secret", value: SecretKey),
			   URLQueryItem(name: "grant_type", value: "authorization_code")
			 ]
			var request = URLRequest(url: urlComponents.url!)
			request.httpMethod = "POST"

			return request
		}
		return nil
	}
}
