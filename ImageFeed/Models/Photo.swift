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
	let createdAt: Date
	let welcomeDescription: String?
	let thumbImageURL: URL
	let largeImageURL: URL
	var isLiked: Bool
}
