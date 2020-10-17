//
//  ReadingHabitsViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 20/07/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

class ReadingHabitsViewController: UIViewController {

	@IBOutlet weak var pagesView: UIView!
	
	@IBOutlet weak var booksView: UIView!
	

	
	override func viewDidLoad() {
		setupUI()
	}
	
	func setupUI() {
		title = "My Reading Habits"
		
		pagesView.round()
		
		booksView.round()


	}
}
