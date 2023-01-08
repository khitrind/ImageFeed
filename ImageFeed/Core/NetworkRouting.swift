//
//  NetworkRouting.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 16/12/2022.
//

import Foundation

enum RequestType {
   case url(url: URL)
   case urlRequest(urlRequest: URLRequest)
}

protocol NetworkClient {
   func fetch<Model: Decodable>(requestType: RequestType, handler: @escaping (Result<Model, Error>) -> Void) -> URLSessionTask
}

final class NetworkRouting: NetworkClient {
	private let jsonDecoder = JSONDecoder()
	private let urlSession: URLSession = URLSession.shared

	private enum NetworkError: LocalizedError {
		case codeError
		case emptyData
		case parsingError

		 public var errorDescription: String? {
			 switch self {
			 case .codeError:
					 return NSLocalizedString("Backend returned non 200 code.", comment: "NetworkClient")
			 case .parsingError:
					 return NSLocalizedString("Parsing model Error", comment: "NetworkClient")
			 case .emptyData:
					 return NSLocalizedString("Empty data Error", comment: "NetworkClient")
			 }
		 }
	 }


	func fetch<Model>(
		requestType: RequestType,
		handler: @escaping (Result<Model, Error>) -> Void)
	-> URLSessionTask where Model : Decodable {
		let request: URLRequest
			 switch requestType {
			 case .url(let url):
				 request = URLRequest(url: url)
			 case .urlRequest(let urlRequest):
				 request = urlRequest
			 }

		let task = urlSession.dataTask(
			with: request
		) { data, response, error in
			if let error = error {
				handler(.failure(error))
				return
			}

			if let response = response as? HTTPURLResponse,
			   response.statusCode < 200 || response.statusCode >= 300 {
				handler(.failure(NetworkError.codeError))
				return

			}
			guard let data = data else {
				handler(.failure(NetworkError.emptyData))
				return
			}

			do {
				let data = try self.jsonDecoder.decode(Model.self, from: data)
				handler(.success(data))

			} catch let error {
				print(error)
				handler(.failure(error))

			}

		}
		task.resume()
		return task
 }
}
