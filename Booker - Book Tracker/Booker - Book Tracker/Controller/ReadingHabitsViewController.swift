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
	
	var estimateWidth = 120.0
	var cellMarginSize = 6.0
	
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
		
		setupGridView()
		
	}
	
	func setupGridView() {
		let flowLayout = monthsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
		flowLayout.minimumInteritemSpacing = CGFloat(cellMarginSize)
		flowLayout.minimumLineSpacing = CGFloat(cellMarginSize)
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

extension ReadingHabitsViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = self.calculateWith()
		return CGSize(width: width, height: width)
	}
	
	func calculateWith() -> CGFloat {
		let estimatedWidth = CGFloat(estimateWidth)
		let cellCount = floor(CGFloat(self.view.frame.size.width / estimatedWidth))
		
		let margin = CGFloat(cellMarginSize * 2)
		let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
		
		return width
	}
}
