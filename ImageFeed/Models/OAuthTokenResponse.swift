//
//  OAuthTokenResponse.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 17/11/2022.
//

import Foundation

//{
//   "access_token": "091343ce13c8ae780065ecb3b13dc903475dd22cb78a05503c2e0c69c5e98044",
//   "token_type": "bearer",
//   "scope": "public read_photos write_photos",
//   "created_at": 1436544465
// }

struct OAuthTokenResponseBody: Decodable {
	let accessToken: String
	let tokenType: String
	let scope: String
	let createdAt: Int

	enum CodingKeys: String, CodingKey {
		case accessToken = "access_token"
		case tokenType = "token_type"
		case scope = "scope"
		case createdAt = "created_at"
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.accessToken = try container.decode(String.self, forKey: .accessToken)
		self.tokenType = try container.decode(String.self, forKey: .tokenType)
		self.scope = try container.decode(String.self, forKey: .scope)
		self.createdAt = try container.decode(Int.self, forKey: .createdAt)
	}
}
