//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 13/11/2022.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
	@IBOutlet private var webView: WKWebView!
	@IBOutlet private var progressView: UIProgressView!

	weak var delegate: WebViewViewControllerDelegate?


	override func viewDidLoad() {
		webView.navigationDelegate = self
		let oauthLink = getOauthLink()
		let request = URLRequest(url: oauthLink)
		webView.load(request)
	}

	private func getOauthLink() -> URL {
		var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize")!
		urlComponents.queryItems = [
		   URLQueryItem(name: "client_id", value: AccessKey),
		   URLQueryItem(name: "redirect_uri", value: RedirectURI),
		   URLQueryItem(name: "response_type", value: "code"),
		   URLQueryItem(name: "scope", value: AccessScope)
		 ]
		return urlComponents.url!
	}

	@IBAction func didTapBackButton(_ sender: Any) {
	}
}


extension WebViewViewController: WKNavigationDelegate {
	private func code(from navigationAction: WKNavigationAction) -> String? {
		if
			let url = navigationAction.request.url,
			let urlComponents = URLComponents(string: url.absoluteString),
			urlComponents.path == "/oauth/authorize/native",
			let items = urlComponents.queryItems,
			let codeItem = items.first(where: { $0.name == "code" })
		{
			return codeItem.value
		} else {
			return nil
		}
	}

	func webView(
		_ webView: WKWebView,
		decidePolicyFor navigationAction: WKNavigationAction,
		decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
	) {
		if code(from: navigationAction) != nil {
				//TODO: process code                     //2
				decisionHandler(.cancel)
		  } else {
				decisionHandler(.allow)
			}
	}
}
