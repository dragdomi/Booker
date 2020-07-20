//
//  habitsScrollView.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 20/07/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

class HabitsScrollView: UIScrollView {
	private let habitsViewContainer = UIView()
	//	var pagesView = UIView?
	var bookView: UIView?
	
	init() {
		super.init(frame:.zero)
		self.addSubview(habitsViewContainer)
		isPagingEnabled = false
		self.bookView = createBookView()
		self.addSubview(bookView!)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
	func createBookView() -> UIView{
		let bookView = UIView()
		let booksInProgressLabel = UILabel()
		booksInProgressLabel.text = "Books in progress: "
		bookView.addSubview(booksInProgressLabel)
		
		return bookView
	}
}
