//
//  BookCell.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 14/07/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {
	@IBOutlet weak var cellView: UIView!
	@IBOutlet weak var coverImage: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var percentageLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var progressBar: HorizontalProgressBar!
	
	func configure() {
		cellView.layer.cornerRadius = 10
		cellView.layer.shadowPath =  UIBezierPath(roundedRect: cellView.bounds, cornerRadius: cellView.layer.cornerRadius).cgPath
		cellView.layer.shadowRadius = 1
		cellView.layer.shadowOffset = .zero
		cellView.layer.shadowOpacity = 0.5
		selectedBackgroundView?.backgroundColor = UIColor(named: "Color1")
		coverImage.layer.cornerRadius = 10
	}
	
	override func prepareForReuse() {
		progressBar.progress = 0
	}
}
