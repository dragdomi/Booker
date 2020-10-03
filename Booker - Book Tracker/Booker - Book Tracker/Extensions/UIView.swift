//
//  UIView.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 03/10/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

extension UIView {
	func round() {
		self.layer.cornerRadius = 10
		self.layer.masksToBounds = true
	}
	
	func addShadow() {
		self.layer.shadowPath =  UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
		self.layer.shadowRadius = 1
		self.layer.shadowOffset = .zero
		self.layer.shadowOpacity = 0.5
	}
}
