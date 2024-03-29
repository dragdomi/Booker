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
	@IBOutlet weak var progressBar: CircularProgressBar!
	
	func configure() {
		cellView.round()
		coverImage.round()
	}
	
	override func prepareForReuse() {
		progressBar.progress = 0
	}
}
