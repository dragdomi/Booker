//
//  UITextView.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 08/10/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

extension UITextView {

	func addDoneButton(title: String, target: Any, selector: Selector) {

		let toolBar = UIToolbar(frame: CGRect(x: 0.0,
											  y: 0.0,
											  width: UIScreen.main.bounds.size.width,
											  height: 44.0))
		let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
		barButton.tintColor = UIColor.interactiveColor
		toolBar.setItems([flexible, barButton], animated: false)
		self.inputAccessoryView = toolBar
	}
}
