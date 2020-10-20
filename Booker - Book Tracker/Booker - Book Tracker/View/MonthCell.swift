//
//  MonthCell.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 20/10/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

class MonthCell: UICollectionViewCell {
	
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var monthLabel: UILabel!
	@IBOutlet weak var booksNumberLabel: UILabel!
	@IBOutlet weak var pagesNumberLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		mainView.round()

	}
	
}
