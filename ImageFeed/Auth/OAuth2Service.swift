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
	}

	func fetchAuthToken(_ code: String, handler: @escaping (Result<String, Error>) -> Void) {
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

			let task = URLSession.shared.dataTask(with: request) { data, response, error in
				if let error = error {
				  handler(.failure(error))
				  return
				}

				if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode >= 300 {
					print(response.statusCode)
				  handler(.failure(NetworkError.codeError))
				  return
				}

				if let data = data {
					do {
						let response = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
						handler(.success(response.accessToken))
					} catch let error {
						handler(.failure(error))
					}
				}
			}

			task.resume()
		}
	}
}
