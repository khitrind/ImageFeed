//
//  OAuthTokenResponse.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 17/11/2022.
//

import Foundation

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
