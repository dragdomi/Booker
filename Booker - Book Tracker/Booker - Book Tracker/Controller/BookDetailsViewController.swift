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
	@IBOutlet weak var percentLabel: UILabel!
	@IBOutlet weak var progressBar: UIProgressView!
	@IBOutlet weak var pagesReadLabel: UILabel!
	@IBOutlet weak var totalPagesLabel: UILabel!
	@IBOutlet weak var lastReadDateLabel: UILabel!
	@IBOutlet weak var beginDateLabel: UILabel!
	@IBOutlet weak var finishDateLabel: UILabel!
	var delegate: BookDetailsViewControllerDelegate?
	
	override func viewDidLoad() {
		updateView(book: book)
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBook))
	}
	
	func updateView(book: BookModel) {
		titleLabel.text = book.title
		authorLabel.text = book.author
		pagesReadLabel.text = "Pages read: " + String(book.pagesRead)
		totalPagesLabel.text = "Total pages: " + String(book.totalPages)
		percentLabel.text = "\(Int(book.readPercentage))%"
		progressBar.progress = Float(book.readPercentage / 100)
		
		if book.lastReadDate != "" {
			lastReadDateLabel.text = "Last read date: " + book.lastReadDate
		} else {
			lastReadDateLabel.text = "Last read date: -"
		}
		
		if book.beginDate != "" {
			beginDateLabel.text = "Begin date: " + book.beginDate
		} else {
			beginDateLabel.text = "Begin date: -"
		}
		
		if book.finishDate != "" {
			finishDateLabel.text = "Finish date: " + book.finishDate
		} else {
			finishDateLabel.text = "Finish date: -"
		}
	}
	
	@objc func editBook() {
		if let addBookViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.addBook) as? AddBookViewController {
			addBookViewController.delegate = self
			addBookViewController.bookId = book.id
			addBookViewController.bookTitle = book.title
			addBookViewController.bookAuthor = book.author
			addBookViewController.bookTotalPages = book.totalPages
			addBookViewController.bookPagesRead = book.pagesRead
			addBookViewController.lastReadDate = formatStringToDate(book.lastReadDate)
			addBookViewController.beginDate = formatStringToDate(book.beginDate)
			addBookViewController.finishDate = formatStringToDate(book.finishDate)
			navigationController?.pushViewController(addBookViewController, animated: true)
		}
	}
	
	func formatDateToString(_ date: Date?) -> String {
		let df = DateFormatter()
		df.dateFormat = Constants.dateFormat
		
		if let date = date {
			let dateString = df.string(from: date)
			return dateString
		} else {
			return ""
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
	
	@IBAction func updateProgress(_ sender: UIButton) {
		let updateView = UIAlertController(title: "Update progress", message: "Enter new number of read pages", preferredStyle: .alert)
		updateView.addTextField { textField in
			textField.placeholder = "Pages"
			textField.keyboardType = .decimalPad
		}
		
		let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak updateView] _ in
			guard let updateView = updateView, let textField = updateView.textFields?.first else { return }
			print("Pages: \(String(describing: textField.text))")
			self.updateBookIfTextfieldIsNotEmpty(textField: textField)
		}
		
		updateView.addAction(confirmAction)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		updateView.addAction(cancelAction)
		updateView.view.tintColor = UIColor(named: "Color4")
		
		present(updateView, animated: true, completion: nil)
	}
	
	func updateBookIfTextfieldIsNotEmpty(textField: UITextField) {
		if textField.text != "" {
			if let updatedPagesRead = Int(textField.text!) {
				try! BookBrain.getRealm().write {
					BookBrain.getRealm().create(BookModel.self, value: ["id":book.id, "pagesRead": updatedPagesRead, "lastReadDate": formatDateToString(Date())], update: .modified)
				}
				
				if (book.pagesRead == book.totalPages) {
					try! BookBrain.getRealm().write {
						BookBrain.getRealm().create(BookModel.self, value: ["id":book.id, "finishDate": book.lastReadDate], update: .modified)
						showBookFinishedView()
					}
				} else {
					try! BookBrain.getRealm().write {
						BookBrain.getRealm().create(BookModel.self, value: ["id":book.id, "finishDate": ""], update: .modified)
					}
				}
				
				handleBookData(self.book)
//				updateView(book: book)
			}
			
		}
		
	}
	
	func showBookFinishedView() {
		let bookFinishedView = UIAlertController(title: "Congratulations! 🥳", message: "You have just finished a book", preferredStyle: .alert)
		bookFinishedView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		bookFinishedView.view.tintColor = UIColor(named: "Color4")
		present(bookFinishedView, animated: true)
	}
	
	
	func handleBookData(_ book: BookModel) {
		delegate?.editBookData(oldBook: self.book, newBook: book)
		self.book = book
		updateView(book: book)
	}
}
