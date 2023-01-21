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

	func fetchAuthToken(_ code: String, handler: @escaping (Result<String, Error>) -> Void) {
		assert(Thread.isMainThread)
		guard lastCode != code, let request = buildRequest(code: code)  else { return }

		task?.cancel()
		lastCode = code

		task = networkClient.fetch(requestType: .urlRequest(urlRequest: request), withToken: false) {[weak self] (response: Result<OAuthTokenResponseBody, Error>) in
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

	private func buildRequest(code: String) -> URLRequest? {
		if var urlComponents = URLComponents(string: tokenURL) {
			urlComponents.queryItems = [
			   URLQueryItem(name: "client_id", value: accessKey),
			   URLQueryItem(name: "redirect_uri", value: redirectURI),
			   URLQueryItem(name: "code", value: code),
			   URLQueryItem(name: "client_secret", value: secretKey),
			   URLQueryItem(name: "grant_type", value: "authorization_code")
			 ]
			var request = URLRequest(url: urlComponents.url!)
			request.httpMethod = "POST"

			return request
		}
		return nil
	}
}
