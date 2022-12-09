//
//  UIImage+Extension.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 09/12/2022.
//

import UIKit

extension UIImage {
	static func asset(_ name: ImageAsset) -> UIImage {
		guard let image = UIImage(named: name.rawValue) else {
			fatalError("Empty asset with name \(name.rawValue)")
		}
		return image
	}
}
