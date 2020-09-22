//
//  HorizontalProgressBar.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 30/07/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class HorizontalProgressBar: UIView {
	@IBInspectable private var color: UIColor? = UIColor(named: "Color4")
	private let progressLayer = CALayer()
	var progress: CGFloat = 0 {
		didSet { setNeedsDisplay() }
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		layer.addSublayer(progressLayer)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		layer.addSublayer(progressLayer)
	}
	
	func setProgress(_ progress: CGFloat) {
		self.progress = progress
	}
	
	override func draw(_ rect: CGRect) {
		let backgroundMask = CAShapeLayer()
		backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.5).cgPath
		layer.mask = backgroundMask
		
		let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * progress, height: rect.height))
		let progressLayer = CALayer()
		progressLayer.frame = progressRect
		
		layer.addSublayer(progressLayer)
		progressLayer.backgroundColor = color?.cgColor
	}
}
