//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 13/12/2022.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
	private static var window: UIWindow? {
		return UIApplication.shared.windows.first
	}

	static func show() {
		DispatchQueue.main.async {
			window?.isUserInteractionEnabled = false
			ProgressHUD.show()
		}
	}

	static func dismiss() {
		DispatchQueue.main.async {
			window?.isUserInteractionEnabled = true
			ProgressHUD.dismiss()
		}
	}
}
