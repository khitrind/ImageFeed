//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 13/11/2022.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
	@IBOutlet private var webView: WKWebView!
	@IBOutlet private var progressView: UIProgressView!

	weak var delegate: WebViewViewControllerDelegate?

	@IBAction func didTapBackButton(_ sender: Any) {
		delegate?.webViewViewControllerDidCancel(self)
	}

	override func viewDidLoad() {
		webView.navigationDelegate = self
		let oauthLink = getOauthLink()
		let request = URLRequest(url: oauthLink)
		webView.load(request)
		updateProgress()
	}

	private func getOauthLink() -> URL {
		var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize")!
		urlComponents.queryItems = [
		   URLQueryItem(name: "client_id", value: AccessKey),
		   URLQueryItem(name: "redirect_uri", value: RedirectURI),
		   URLQueryItem(name: "response_type", value: "code"),
		   URLQueryItem(name: "scopes", value: AccessScope)
		 ]
		return urlComponents.url!
	}


	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		webView.addObserver(
			self,
			forKeyPath: #keyPath(WKWebView.estimatedProgress),
			options: .new,
			context: nil)
		updateProgress()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
	}


	override func observeValue(
		forKeyPath keyPath: String?,
		of object: Any?,
		change: [NSKeyValueChangeKey : Any]?,
		context: UnsafeMutableRawPointer?
	) {
		if keyPath == #keyPath(WKWebView.estimatedProgress) {
			updateProgress()
		} else {
			super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
		}
	}

	private func updateProgress() {
		progressView.progress = Float(webView.estimatedProgress)
		progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
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
		if let code = code(from: navigationAction) {
			delegate?.webViewViewController(self, didAuthenticateWithCode: code)
			decisionHandler(.cancel)
		} else {
			decisionHandler(.allow)
		}
	}
}
