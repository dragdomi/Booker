//
//  File.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 07/10/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

extension UIButton {
	func alignImageAndTitleVertically(padding: CGFloat = 6.0) {
		let imageSize = self.imageView!.frame.size
		let titleSize = self.titleLabel!.frame.size
		let totalHeight = imageSize.height + titleSize.height + padding

		self.imageEdgeInsets = UIEdgeInsets(
			top: -(totalHeight - imageSize.height),
			left: 0,
			bottom: 0,
			right: -titleSize.width
		)

		self.titleEdgeInsets = UIEdgeInsets(
			top: 0,
			left: -imageSize.width,
			bottom: -(totalHeight - titleSize.height),
			right: 0
		)
	}

}
