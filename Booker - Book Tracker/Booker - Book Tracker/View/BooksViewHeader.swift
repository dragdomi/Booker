//
//  BooksViewHeader.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 05/09/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

class BooksViewHeader: UITableViewHeaderFooterView {
	static let height: CGFloat = 70
	var presenter: BooksViewController?
	var isFiltering: Bool?
	var isSorting: Bool?
	
	@IBOutlet weak var headerLabel: UILabel!
	@IBOutlet weak var filterSegmentedControl: UISegmentedControl!
	
	@IBAction func filterSegmentedControlChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			presenter?.reloadBooks()
			updateLabel(description: sender.titleForSegment(at: sender.selectedSegmentIndex))
			
		case 1:
			presenter?.reloadBooks(filterBy: "inProgress")
			updateLabel(description: sender.titleForSegment(at: sender.selectedSegmentIndex))
			
		case 2:
			presenter?.reloadBooks(filterBy: "finished")
			updateLabel(description: sender.titleForSegment(at: sender.selectedSegmentIndex))
			
		case 3:
			presenter?.reloadBooks(filterBy: "notStarted")
			updateLabel(description: sender.titleForSegment(at: sender.selectedSegmentIndex))
			
		default:
			presenter?.reloadBooks()
			updateLabel(description: sender.titleForSegment(at: sender.selectedSegmentIndex))
		}
	}
	
	@IBAction func sortButtonPressed(_ sender: Any) {
		let sortMenu = UIAlertController(title: "Order By ", message: nil, preferredStyle: .actionSheet)
		
		let sortByTitleAction = UIAlertAction(title: "Title", style: .default) { _ in
			self.presenter?.reloadBooks(sortBy: "title")
		}
		
		let sortByAuthorAction = UIAlertAction(title: "Author", style: .default) { _ in
			self.presenter?.reloadBooks(sortBy: "author")
		}
		
		let sortByProgressAction = UIAlertAction(title: "Progress", style: .default) { _ in
			self.presenter?.reloadBooks(sortBy: "progress")
		}
		
		let sortByBeginDateAction = UIAlertAction(title: "Begin Date", style: .default) { _ in
			self.presenter?.reloadBooks(sortBy: "beginDate")
		}
		
		let sortByFinishDateAction = UIAlertAction(title: "Finish Date", style: .default) { _ in
			self.presenter?.reloadBooks(sortBy: "finishDate")
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		sortMenu.addAction(sortByTitleAction)
		sortMenu.addAction(sortByAuthorAction)
		sortMenu.addAction(sortByProgressAction)
		sortMenu.addAction(sortByBeginDateAction)
		sortMenu.addAction(sortByFinishDateAction)
		sortMenu.addAction(cancelAction)
		sortMenu.view.tintColor = UIColor(named: "Color4")
		
		presenter?.present(sortMenu, animated: true, completion: nil)
	}
	
	func updateLabel(description: String?) {
		if let booksCount = presenter?.books.count, let description = description {
			headerLabel.text = "\(description) (\(booksCount))"
		} else {
			headerLabel.text = ""
		}
	}
}
