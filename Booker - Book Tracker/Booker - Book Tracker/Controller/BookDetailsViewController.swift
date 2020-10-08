//
//  BookDetailsViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 18/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit
import Cosmos

protocol BookDetailsViewControllerDelegate {
	func editBookData(_ editedBook: BookModel)
}

class BookDetailsViewController: UIViewController, AddBookViewControllerDelegate, NotesViewControllerDelegate {
	var book: BookModel!
	var editedBook: BookModel?
	var delegate: BookDetailsViewControllerDelegate?
	
	@IBOutlet weak var infoView: UIView!
	
	@IBOutlet weak var bookCover: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var ratingView: CosmosView!
	
	@IBOutlet weak var readStateLabel: UILabel!
	@IBOutlet weak var progressLabel: UILabel!
	@IBOutlet weak var totalPagesLabel: UILabel!
	@IBOutlet weak var readTimeLabel: UILabel!
	@IBOutlet weak var progressBar: CircularProgressBar!
	
	@IBOutlet weak var beginDateLabel: UILabel!
	@IBOutlet weak var lastReadDateLabel: UILabel!
	@IBOutlet weak var finishDateLabel: UILabel!
	
	@IBOutlet weak var updateProgressButton: UIButton!
	@IBOutlet weak var notesButton: UIButton!
	@IBOutlet weak var quotesButton: UIButton!
	@IBOutlet weak var editButton: UIButton!
	
	
	@IBAction func updateProgress(_ sender: UIButton) {
		let updateView = UIAlertController(title: "Update progress", message: "Enter new number of read pages", preferredStyle: .alert)
		updateView.addTextField { textField in
			textField.placeholder = "Pages"
			textField.keyboardType = .decimalPad
		}
		
		let confirmAction = UIAlertAction(title: "Done", style: .default) { [weak updateView] _ in
			guard let updateView = updateView, let textField = updateView.textFields?.first else { return }
			print("Pages: \(String(describing: textField.text))")
			self.updateBookIfTextfieldIsNotEmpty(textField: textField)
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		updateView.addAction(confirmAction)
		updateView.addAction(cancelAction)
		updateView.view.tintColor = .systemIndigo
		
		present(updateView, animated: true, completion: nil)
	}
	
	@IBAction func notesButtonTapped(_ sender: UIButton) {
		if let notesViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.notes) as? NotesViewController {
			notesViewController.delegate = self
			notesViewController.notes = book.notes
			navigationController?.present(notesViewController, animated: true, completion: nil)
		}
	}
	
	@IBAction func editButtonTapped(_ sender: UIButton) {
		if let addBookViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.addBook) as? AddBookViewController {
			addBookViewController.delegate = self
			addBookViewController.title = "Edit Book"
			addBookViewController.bookID = book.id
			addBookViewController.bookCover = book.cover
			addBookViewController.bookTitle = book.title
			addBookViewController.bookAuthor = book.author
			addBookViewController.bookTotalPages = book.totalPages
			addBookViewController.bookPagesRead = book.pagesRead
			addBookViewController.beginDate = Utils.formatStringToDate(book.beginDate)
			addBookViewController.finishDate = Utils.formatStringToDate(book.finishDate)
			navigationController?.pushViewController(addBookViewController, animated: true)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureView()
		updateView(book: book)
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: nil)
	}
	
	func configureView() {
		configureContainerView()
		configureImageView()
		configureRatingView()
		configureButtons()
	}
	
	func configureContainerView () {
		infoView.round()
	}
	
	func configureImageView() {
		bookCover.round()
	}
	
	func configureButtons() {
		updateProgressButton.round()
		updateProgressButton.alignImageAndTitleVertically()
		notesButton.round()
		notesButton.alignImageAndTitleVertically()
		quotesButton.round()
		quotesButton.alignImageAndTitleVertically()
		editButton.round()
		editButton.alignImageAndTitleVertically()
	}
	
	func configureRatingView() {
		ratingView.didTouchCosmos = { rating in
			try! BookBrain.getRealm().write {
				BookBrain.getRealm().create(BookModel.self, value: ["id": self.book.id, "rating": rating], update: .modified)
			}
			self.ratingView.rating = rating
		}
	}
	
	func updateView(book: BookModel) {
		if let coverImage = ImageManager.retrieveImage(forKey: book.cover) {
			bookCover.image = coverImage
		} else {
			bookCover.image = ImageManager.defaultBookCover
		}
		
		bookCover.image = ImageManager.retrieveImage(forKey: book.cover)
		titleLabel.text = book.title
		authorLabel.text = book.author
		
		readStateLabel.text = " \(book.getReadingState())"
		progressLabel.text = " \(Int(book.getPercentage()))% (Page \(book.pagesRead))"
		totalPagesLabel.text = " \(book.totalPages)"
		readTimeLabel.text = " \(book.getReadTime()) \(getReadTimeUnit())"
		progressBar.setProgress(CGFloat(book.getPercentage() / 100.0))
		
		if book.beginDate != "" {
			beginDateLabel.text = " \(book.beginDate)"
		} else {
			beginDateLabel.text = " -"
		}
		
		if book.lastReadDate != "" {
			lastReadDateLabel.text = " \(book.lastReadDate)"
		} else {
			lastReadDateLabel.text = " -"
		}
		
		if book.finishDate != "" {
			finishDateLabel.text = " \(book.finishDate)"
		} else {
			finishDateLabel.text = " -"
		}
		
		ratingView.rating = book.rating
	}
	
	func getReadTimeUnit() -> String {
		if book.getReadTime() == 1 {
			return "day"
		} else {
			return "days"
		}
	}
	
	func updateBookIfTextfieldIsNotEmpty(textField: UITextField) {
		if textField.text != "" {
			if let updatedPagesRead = Int(textField.text!) {
				if (updatedPagesRead - book.pagesRead) >= 0 {
					ReadingInfo.addPagesToDate(pages: updatedPagesRead - book.pagesRead, date: Utils.formatDateToString(Date()))
				} else {
					showSubstractAlert(negativeNumber: updatedPagesRead - book.pagesRead)
				}
				
				try! BookBrain.getRealm().write {
					BookBrain.getRealm().create(BookModel.self, value: ["id":book.id, "pagesRead": updatedPagesRead, "lastReadDate": Utils.formatDateToString(Date())], update: .modified)
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
			}
		}
	}
	
	func showSubstractAlert(negativeNumber: Int) {
		let substractAlert = UIAlertController(title: "Negative number", message: "Do you want to substract \(abs(negativeNumber)) from your daily pages score?", preferredStyle: .alert)
		let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
			ReadingInfo.addPagesToDate(pages: negativeNumber, date: Utils.formatDateToString(Date()))
		}
		let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
		
		substractAlert.addAction(yesAction)
		substractAlert.addAction(noAction)
		substractAlert.view.tintColor = .systemIndigo
		
		present(substractAlert, animated: true, completion: nil)
	}
	
	func showBookFinishedView() {
		let bookFinishedView = UIAlertController(title: "Congratulations! 🥳", message: "You have just finished a book", preferredStyle: .alert)
		bookFinishedView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		bookFinishedView.view.tintColor = .systemIndigo
		present(bookFinishedView, animated: true)
	}
	
	func handleBookData(_ book: BookModel) {
		delegate?.editBookData(book)
		self.book = book
		updateView(book: book)
	}
	
	func updateNotes(with notes: String) {
		BookBrain.editBookNotes(book: book, notes: notes)
	}
}
