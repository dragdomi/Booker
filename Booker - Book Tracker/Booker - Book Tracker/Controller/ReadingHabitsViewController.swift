//
//  ReadingHabitsViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 20/07/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

class ReadingHabitsViewController: UIViewController {
	@IBOutlet weak var booksView: UIView!
	@IBOutlet weak var booksNotStartedLabel: UILabel!
	@IBOutlet weak var booksInProgressLabel: UILabel!
	@IBOutlet weak var booksReadLabel: UILabel!
	
	@IBOutlet weak var pagesView: UIView!
	@IBOutlet weak var totalPagesReadLabel: UILabel!
	@IBOutlet weak var totalPagesOfBooksLabel: UILabel!
	@IBOutlet weak var totalPagesLeftLabel: UILabel!
	
	override func viewDidLoad() {
		setupUI()
	}
	
	func setupUI() {
		title = "My Reading Habits"
		
		booksNotStartedLabel.text = "Books not started: \(ReadingInfo.getBooksNotStartedNumber())"
		booksInProgressLabel.text = "Books in progress: \(ReadingInfo.getBooksInProgressNumber())"
		booksReadLabel.text = "Books read: \(ReadingInfo.getBooksReadNumber())"
		
		totalPagesReadLabel.text = "Total pages read: \(ReadingInfo.getTotalPagesReadNumber())"
		totalPagesOfBooksLabel.text = "Total pages of books: \(ReadingInfo.getTotalPagesNumber())"
		totalPagesLeftLabel.text = "Total pages left: \(ReadingInfo.getTotalPagesLeftNumber())"
		
		booksView.round()
		pagesView.round()
		
		//		pagesPerDayLabel.text = "Pages read on \(Utils.formatDateToString(Date())): \(ReadingHabits.getPagesPerDate(date: Utils.formatDateToString(Date())))"
	}
	
	
	
}
