//
//  TabBarController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 02/11/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	func setupUI() {
		navigationItem.hidesBackButton = true
	}
}
