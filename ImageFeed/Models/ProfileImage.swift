//
//  UserResult.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 19/12/2022.
//

import Foundation

struct ProfileImage: Codable {
	let small: String?
	let medium: String?
	let large: String?

	var image: String? { large ?? medium ?? small }
}
