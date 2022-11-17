//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 17/11/2022.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
	func webViewViewControllerDidCancel(_ vc: WebViewViewController)
	func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
}
