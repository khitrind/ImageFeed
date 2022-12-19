//
//  UserPublicProfile.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 19/12/2022.
//

import Foundation

struct UserProfile: Codable {
	let profileImage: ProfileImage?

	enum CodingKeys: String, CodingKey {
		case profileImage = "profile_image"
	}
}
