//
//  ReadingHabitsViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 20/07/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit
import Charts

class ReadingHabitsViewController: UIViewController {
	@IBOutlet weak var booksView: UIView!
	@IBOutlet weak var booksNotStartedLabel: UILabel!
	@IBOutlet weak var booksInProgressLabel: UILabel!
	@IBOutlet weak var booksReadLabel: UILabel!
	
	@IBOutlet weak var pagesView: UIView!
	@IBOutlet weak var totalPagesReadLabel: UILabel!
	@IBOutlet weak var totalPagesOfBooksLabel: UILabel!
	@IBOutlet weak var totalPagesLeftLabel: UILabel!
	
	lazy var pieChartView = PieChartView()
	
	
	override func viewDidLoad() {
		setupUI()
	}
	
	func setupUI() {
		title = "My Reading Habits"
		
		booksNotStartedLabel.text = "Books not started: \(ReadingHabits.getBooksNotStartedNumber())"
		booksInProgressLabel.text = "Books in progress: \(ReadingHabits.getBooksInProgressNumber())"
		booksReadLabel.text = "Books read: \(ReadingHabits.getBooksReadNumber())"
		
		totalPagesReadLabel.text = "Total pages read: \(ReadingHabits.getTotalPagesReadNumber())"
		totalPagesOfBooksLabel.text = "Total pages of books: \(ReadingHabits.getTotalPagesNumber())"
		totalPagesLeftLabel.text = "Total pages left: \(ReadingHabits.getTotalPagesLeftNumber())"
		
		booksView.layer.cornerRadius = 10
		booksView.layer.shadowPath =  UIBezierPath(roundedRect: booksView.bounds, cornerRadius: booksView.layer.cornerRadius).cgPath
		booksView.layer.shadowRadius = 1
		booksView.layer.shadowOffset = .zero
		booksView.layer.shadowOpacity = 0.5
		
		pagesView.layer.cornerRadius = 10
		booksView.layer.shadowPath =  UIBezierPath(roundedRect: booksView.bounds, cornerRadius: booksView.layer.cornerRadius).cgPath
		pagesView.layer.shadowRadius = 1
		pagesView.layer.shadowOffset = .zero
		pagesView.layer.shadowOpacity = 0.5
		
		//		pagesPerDayLabel.text = "Pages read on \(Utils.formatDateToString(Date())): \(ReadingHabits.getPagesPerDate(date: Utils.formatDateToString(Date())))"
	}
	
	
	
}
