//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 11/01/2023.
//

import Foundation

struct PhotoResult: Decodable  {
	let id: String
	let createdAt: String
	let width: Int
	let height: Int
	let isLiked: Bool
	let description: String?
	let urls: UrlsResult

	struct UrlsResult: Decodable {
		let full: URL
		let small: URL
		let thumb: URL
	}


	enum CodingKeys: String, CodingKey {
		case id, width, height, description, urls
		case isLiked = "liked_by_user"
		case createdAt = "created_at"
	}
}
