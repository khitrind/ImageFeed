//
//  Date+Extension.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 23/01/2023.
//

import UIKit

extension DateFormatter {
	var displayFormat: DateFormatter {
		self.dateStyle = .long
		self.timeStyle = .none
		return self
	}
}
