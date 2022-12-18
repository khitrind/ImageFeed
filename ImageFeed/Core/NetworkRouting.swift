//
//  NetworkRouting.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 16/12/2022.
//

import Foundation

protocol NetworkClient {
	func fetch<Model: Decodable>(
		url: URL,
		handler: @escaping (Result<Model, Error>) -> Void
	) -> URLSessionTask

	func fetch<Model: Decodable>(
		request: URLRequest,
		handler: @escaping (Result<Model, Error>) -> Void
	) -> URLSessionTask
}


final class NetworkRouting: NetworkClient {
	private let jsonDecoder = JSONDecoder()
	private let urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default)

	private enum NetworkError: LocalizedError {
		case codeError
		case parsingError

		 public var errorDescription: String? {
			 switch self {
			 case .codeError:
				 return NSLocalizedString("Backend returned non 200 code.", comment: "NetworkClient")
			 case .parsingError:
				 return NSLocalizedString("Parsing model Error", comment: "NetworkClient")

			 }
		 }
	 }

	public func fetch<Model: Decodable>(
		url: URL,
		handler: @escaping (Result<Model, Error>) -> Void
	) -> URLSessionTask  {
		let request = URLRequest(url: url)
		return fetch(request: request, handler: handler)
	}


	public func fetch<Model: Decodable>(
	 request: URLRequest,
	 handler: @escaping (Result<Model, Error>) -> Void
 ) -> URLSessionTask {
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

		 guard let data = data else { return }
		 print(data)

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
