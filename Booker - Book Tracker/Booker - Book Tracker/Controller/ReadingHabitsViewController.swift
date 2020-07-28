//
//  ReadingHabitsViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 20/07/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

class ReadingHabitsViewController: UIViewController {
	@IBOutlet weak var habitsScrollView: UIScrollView!
	@IBOutlet weak var booksNotStartedLabel: UILabel!
	@IBOutlet weak var booksInProgressLabel: UILabel!
	@IBOutlet weak var booksReadLabel: UILabel!
	@IBOutlet weak var pagesPerDayLabel: UILabel!
	
	override func viewDidLoad() {
		title = "My Reading Habits"
		
		booksNotStartedLabel.text = "Books not started: \(ReadingHabits.booksNotStartedNumber)"
		booksInProgressLabel.text = "Books in progress: \(ReadingHabits.booksInProgressNumber)"
		booksReadLabel.text = "Books read: \(ReadingHabits.booksReadNumber)"
		pagesPerDayLabel.text = "Pages read on \(Utils.formatDateToString(Date())): \(ReadingHabits.getPagesPerDate(date: Utils.formatDateToString(Date())))"
	}
}
