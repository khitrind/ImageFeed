//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 21/11/2022.
//

import Foundation
import SwiftKeychainWrapper


protocol OAuth2TokenStorageProtocol {
	var token: String? { get set }
}

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
	private enum Keys: String {
		case bearerToken
	}

	private let keychainWrapper = KeychainWrapper.standard

	var token: String? {
	  get {
		  return keychainWrapper.string(forKey: Keys.bearerToken.rawValue)
	  }
	  set {
		  if let token = newValue {
			  keychainWrapper.set(token, forKey: Keys.bearerToken.rawValue)
		  }
	  }
	}

	func clearToken() {
		keychainWrapper.removeAllKeys()
	}
}
