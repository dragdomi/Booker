//
//  QuoteCell.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 08/10/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

class QuoteCell: UITableViewCell {
	@IBOutlet weak var quoteImage: UIImageView!
	@IBOutlet weak var quoteLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
