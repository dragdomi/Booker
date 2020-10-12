//
//  QuoteViewHeader.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 12/10/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

class QuotesViewHeader: UITableViewHeaderFooterView {
	static let height: CGFloat = 40
	var presenter: QuotesViewController?
	@IBOutlet weak var titleLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		updateLabel()
	}
	
	func updateLabel() {
		if let quotesCount = presenter?.quotes.count, let title = presenter?.book?.title {
			titleLabel.text = "Quotes (\(quotesCount))"
		}
	}
}
