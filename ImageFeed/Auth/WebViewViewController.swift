//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 13/11/2022.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
	func webViewViewControllerDidCancel(_ vc: WebViewViewController)
	func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
}


final class WebViewViewController: UIViewController {
	@IBOutlet private weak var webView: WKWebView!
	@IBOutlet private weak var progressView: UIProgressView!
	private var estimatedProgressObservation: NSKeyValueObservation?

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
		var urlComponents = URLComponents(string: authorizeURL)!
		urlComponents.queryItems = [
		   URLQueryItem(name: "client_id", value: accessKey),
		   URLQueryItem(name: "redirect_uri", value: redirectURI),
		   URLQueryItem(name: "response_type", value: "code"),
		   URLQueryItem(name: "scopes", value: accessScope)
		 ]
		return urlComponents.url!
	}


	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		estimatedProgressObservation = webView.observe(
					\.estimatedProgress,
					options: [],
					changeHandler: { [weak self] _, _ in
						guard let self = self else { return }
						self.updateProgress()
					})
	}

	private func updateProgress() {
		progressView.progress = Float(webView.estimatedProgress)
		progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
	}
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
	private func code(from navigationAction: WKNavigationAction) -> String? {
		if
			let url = navigationAction.request.url,
			let urlComponents = URLComponents(string: url.absoluteString),
			urlComponents.path == nativePath,
			let items = urlComponents.queryItems,
			let codeItem = items.first(where: { $0.name == "code" })
		{
			return codeItem.value
		}
		return nil
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

	static func clean() {
	   // Очищаем все куки из хранилища.
	   HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
	   // Запрашиваем все данные из локального хранилища.
	   WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
		  // Массив полученных записей удаляем из хранилища.
		  records.forEach { record in
			 WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
		  }
	   }
	}
}
