//
//  BookDetailsViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 18/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

protocol BookDetailsViewControllerDelegate {
	func editBookData(oldBook: BookModel, newBook: BookModel)
}

class BookDetailsViewController: UIViewController, AddBookViewControllerDelegate {
	var book: BookModel!
	
	var editedBook: BookModel?
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var pagesReadLabel: UILabel!
	@IBOutlet weak var totalPagesLabel: UILabel!
	@IBOutlet weak var beginDateLabel: UILabel!
	@IBOutlet weak var finishDateLabel: UILabel!
	var delegate: BookDetailsViewControllerDelegate?
	
	override func viewDidLoad() {
		updateView(book: book)
	}
	
	func updateView(book: BookModel) {
		titleLabel.text = book.title
		authorLabel.text = book.author
		pagesReadLabel.text = "Pages read: " + String(book.pagesRead)
		totalPagesLabel.text = "Total pages: " + String(book.totalPages)
		
		if book.beginDate != "" {
			beginDateLabel.text = "Begin date: " + book.beginDate
		}
		
		if book.finishDate != "" {
			finishDateLabel.text = "Finish date: " + book.finishDate
		}
	}
	
	@IBAction func editBookDataButtonPressed(_ sender: UIButton) {
		if let addBookViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.addBook) as? AddBookViewController {
			addBookViewController.delegate = self
			addBookViewController.bookId = book.id
			addBookViewController.bookTitle = book.title
			addBookViewController.bookAuthor = book.author
			addBookViewController.bookTotalPages = book.totalPages
			addBookViewController.bookPagesRead = book.pagesRead
			addBookViewController.beginDate = formatStringToDate(book.beginDate)
			addBookViewController.finishDate = formatStringToDate(book.finishDate)
			navigationController?.pushViewController(addBookViewController, animated: true)
		}
	}
	
	func formatStringToDate(_ string: String) -> Date?{
		let df = DateFormatter()
		df.dateFormat = Constants.dateFormat
		
		if string != "" {
			let date = df.date(from: string)
			return date
		} else {
			return nil
		}
	}
	
	func handleBookData(_ book: BookModel) {
		delegate?.editBookData(oldBook: self.book, newBook: book)
		self.book = book
		updateView(book: book)
		BookBrain.editBookData(oldBookData: self.book, newBookData: book)
	}
}
