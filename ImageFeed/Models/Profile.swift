//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 18/12/2022.
//

import Foundation

struct Profile: Decodable {
	let username: String
	let name: String
	let bio: String
	var login: String {"@\(username)"}

	enum CodingKeys: String, CodingKey {
		case username = "username"
		case name = "name"
		case bio = "bio"
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.name = try container.decode(String.self, forKey: .name)

		bio = try container.decodeIfPresent(String.self, forKey: .bio) ?? ""
		
		let username = try container.decode(String.self, forKey: .username)
		self.username = username
	}
}
