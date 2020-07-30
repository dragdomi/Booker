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
	lazy var pieChartView = PieChartView()
	
	
	override func viewDidLoad() {
		setupUI()
	}
	
	func setupUI() {
		title = "My Reading Habits"
		
		booksNotStartedLabel.text = "Books not started: \(ReadingHabits.booksNotStartedNumber)"
		booksInProgressLabel.text = "Books in progress: \(ReadingHabits.booksInProgressNumber)"
		booksReadLabel.text = "Books read: \(ReadingHabits.booksReadNumber)"
		booksView.addSubview(pieChartView)
		
		pieChartView.translatesAutoresizingMaskIntoConstraints = false
		
		pieChartView.leadingAnchor.constraint(equalTo: booksView.leadingAnchor).isActive = true
		pieChartView.trailingAnchor.constraint(equalTo: booksView.trailingAnchor).isActive = true
		pieChartView.topAnchor.constraint(equalTo: booksReadLabel.bottomAnchor).isActive = true
		pieChartView.bottomAnchor.constraint(equalTo: booksView.bottomAnchor).isActive = true
		setup(pieChartView: pieChartView)
		
//		pagesPerDayLabel.text = "Pages read on \(Utils.formatDateToString(Date())): \(ReadingHabits.getPagesPerDate(date: Utils.formatDateToString(Date())))"
	}
	
	func setup(pieChartView chartView: PieChartView) {
			chartView.usePercentValuesEnabled = true
			chartView.drawSlicesUnderHoleEnabled = false
			chartView.holeRadiusPercent = 0.58
			chartView.transparentCircleRadiusPercent = 0.61
			chartView.chartDescription?.enabled = false
			chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
			
			chartView.drawCenterTextEnabled = true
			
			let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
			paragraphStyle.lineBreakMode = .byTruncatingTail
			paragraphStyle.alignment = .center
			
			let centerText = NSMutableAttributedString(string: "Charts\nby Daniel Cohen Gindi")
			centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 13)!,
									  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
			centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
									  .foregroundColor : UIColor.gray], range: NSRange(location: 10, length: centerText.length - 10))
			centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
									  .foregroundColor : UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)], range: NSRange(location: centerText.length - 19, length: 19))
			chartView.centerAttributedText = centerText;
			
			chartView.drawHoleEnabled = true
			chartView.rotationAngle = 0
			chartView.rotationEnabled = true
			chartView.highlightPerTapEnabled = true
			
			let l = chartView.legend
			l.horizontalAlignment = .right
			l.verticalAlignment = .top
			l.orientation = .vertical
			l.drawInside = false
			l.xEntrySpace = 7
			l.yEntrySpace = 0
			l.yOffset = 0
	//        chartView.legend = l
		}
}
