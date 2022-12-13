//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 17/11/2022.
//

import Foundation

final class OAuth2Service {
	private enum NetworkError: Error {
		case codeError
		case dataError
	}

	private var lastCode: String?
	private var task: URLSessionTask?
	private let jsonDecoder = JSONDecoder()
	private let urlSession = URLSession.shared

	func fetchAuthToken(_ code: String, handler: @escaping (Result<Data, Error>) -> Void) {
		assert(Thread.isMainThread)
		if lastCode == code { return }
		task?.cancel()
		lastCode = code

		if var request = makeRequest(code: code) {
			let task = urlSession.dataTask(with: request) {[weak self] data, response, error in
				guard let self = self else {return}
				self.task = nil
				
				switch self.prepareResponse(data, response, error) {
				case .success(let data):
						DispatchQueue.main.async {handler(.success(data))}
				case .failure(let error):
						self.lastCode = nil
						DispatchQueue.main.async {handler(.failure(error))}
				}
			}
			self.task = task
			task.resume()
		}
	}

	private func prepareResponse(_ data: Data?, _ response: URLResponse?, _ error: Error? ) -> Result<Data, Error> {
		if let error = error {
			return .failure(error)
		}

		if let response = response as? HTTPURLResponse,
		   response.statusCode < 200 || response.statusCode >= 300 {
			return .failure(NetworkError.codeError)
		}

		if let data = data {
			return .success(data)
		}

		return .failure(NetworkError.dataError)
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
