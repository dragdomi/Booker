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
	@IBOutlet weak var pagesView: UIView!
	
	@IBOutlet weak var booksView: UIView!
	
	@IBOutlet weak var monthsCollectionView: UICollectionView!
	
	let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		
		monthsCollectionView.delegate = self
		monthsCollectionView.dataSource = self
		monthsCollectionView.register(UINib(nibName: Constants.monthCellNibName, bundle: .main), forCellWithReuseIdentifier: Constants.monthCellIdentifier)
	}
	
	func setupUI() {
		title = "My Reading Habits"
		
		pagesView.round()
		
		booksView.round()

	}

}

extension ReadingHabitsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return months.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = monthsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.monthCellIdentifier, for: indexPath) as! MonthCell
		cell.monthLabel.text = months[indexPath.row]
		
		return cell
	}
}
