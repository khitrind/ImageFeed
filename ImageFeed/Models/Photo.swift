//
//  Photo.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 11/01/2023.
//

import Foundation

struct Photo {
	let id: String
	let size: CGSize
	let createdAt: Date?
	let welcomeDescription: String?
	let thumbImageURL: URL
	let largeImageURL: URL
	var isLiked: Bool

	static func fromPhotoResult(from data: PhotoResult) -> Photo {

		return Photo(
			id: data.id,
			size: CGSize(width: data.width, height: data.height),
			createdAt: DateFormatter().date(from: data.createdAt),
			welcomeDescription: data.description,
			thumbImageURL: data.urls.thumb,
			largeImageURL: data.urls.full,
			isLiked: data.isLiked
		)
	}
}
