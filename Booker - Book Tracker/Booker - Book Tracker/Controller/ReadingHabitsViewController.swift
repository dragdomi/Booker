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
	@IBOutlet weak var pagesReadLabel: UILabel!
	@IBOutlet weak var pagesTotalLabel: UILabel!
	@IBOutlet weak var pagesLeftLabel: UILabel!
	
	@IBOutlet weak var booksView: UIView!
	@IBOutlet weak var booksReadLabel: UILabel!
	@IBOutlet weak var booksInProgressLabel: UILabel!
	@IBOutlet weak var booksNotStartedLabel: UILabel!
	
	@IBOutlet weak var monthsCollectionView: UICollectionView!
	
	@IBOutlet weak var yearLabel: UILabel!
	
	var months = Utils.months
	
	var year: Int = Date().get(.year)
	
	@IBAction func previousYearButtonTapped(_ sender: UIButton) {
		year -= 1
		updateUI()
	}
	
	@IBAction func nextYearButtonTapped(_ sender: UIButton) {
		year += 1
		updateUI()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		
		monthsCollectionView.delegate = self
		monthsCollectionView.dataSource = self
		monthsCollectionView.register(UINib(nibName: Constants.monthCellNibName, bundle: .main), forCellWithReuseIdentifier: Constants.monthCellIdentifier)
	}
	
	//MARK: - UI
	
	func setupUI() {
		title = "Habits"
		setupPagesView()
		setupBooksView()
		yearLabel.text = String(year)
	}
	
	func setupPagesView() {
		pagesView.round()
		pagesReadLabel.text = String(ReadingHabits.getTotalPagesReadNumber())
		pagesTotalLabel.text = String(ReadingHabits.getTotalPagesNumber())
		pagesLeftLabel.text = String(ReadingHabits.getTotalPagesLeftNumber())
		
	}
	
	func setupBooksView() {
		booksView.round()
		booksReadLabel.text = String(ReadingHabits.getBooksReadNumber())
		booksInProgressLabel.text = String(ReadingHabits.getBooksInProgressNumber())
		booksNotStartedLabel.text = String(ReadingHabits.getBooksNotStartedNumber())
	}
	
	func updateUI() {
		yearLabel.text = String(year)
		monthsCollectionView.reloadData()
	}
}

//MARK: - Extensions

extension ReadingHabitsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return months.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = monthsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.monthCellIdentifier, for: indexPath) as! MonthCell
		let year = yearLabel.text ?? "0"
		let month = months[indexPath.row]
		let monthNumber = String(Utils.monthsNumbers[month] ?? 0)
		cell.monthLabel.text = months[indexPath.row]
		cell.pagesNumberLabel.text = String(ReadingEntriesBrain.getPagesPerMonth(month: monthNumber, year: year))
		cell.booksNumberLabel.text = String(ReadingEntriesBrain.getBooksNumberPerMonth(month: monthNumber, year: year))
		
		return cell
	}
}
