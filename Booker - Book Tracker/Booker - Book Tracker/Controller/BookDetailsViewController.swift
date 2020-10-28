//
//  BookDetailsViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 18/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit
import Cosmos
import RealmSwift

protocol BookDetailsViewControllerDelegate {
	func editBookData(_ editedBook: BookModel)
}

class BookDetailsViewController: UIViewController {
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
	
	@IBOutlet weak var finishBookButton: UIButton!
	@IBOutlet weak var updateProgressButton: UIButton!
	@IBOutlet weak var notesButton: UIButton!
	@IBOutlet weak var quotesButton: UIButton!
	@IBOutlet weak var editButton: UIButton!
	
	var book: BookModel!
	var editedBook: BookModel?
	var delegate: BookDetailsViewControllerDelegate?
	
	@IBAction func finishBookButtonTapped(_ sender: UIButton) {
		let date = Utils.formatDateToString(Date())
		if !book.isFinished() {
			let pagesToAdd = book.totalPages - book.pagesRead
			ReadingEntriesBrain.addPagesToEntry(with: date, pages: pagesToAdd)
			ReadingEntriesBrain.addBookToEntry(with: date, book: book)
			
			try! RealmController.getBooksRealm().write {
				RealmController.getBooksRealm().create(BookModel.self, value: ["id":book.id, "pagesRead": book.totalPages, "lastReadDate": date, "finishDate": date], update: .modified)
			}
			
			handleBookData(book)
			showBookFinishedView()
		} else {
			showBookAlreadyFinishedView()
		}
	}
	
	@IBAction func updateProgressButtonTapped(_ sender: UIButton) {
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
		updateView.view.tintColor = .accent
		
		present(updateView, animated: true, completion: nil)
	}
	
	@IBAction func notesButtonTapped(_ sender: UIButton) {
		if let notesViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.notes) as? NotesViewController {
			notesViewController.delegate = self
			notesViewController.notes = book.notes
			navigationController?.present(notesViewController, animated: true, completion: nil)
		}
	}
	
	@IBAction func quotesButtonTapped(_ sender: UIButton) {
		if let quotesViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.quotes) as? QuotesViewController {
			quotesViewController.delegate = self
			let quotes = Utils.getArrayFromList(book.quotes)
			quotesViewController.book = book
			quotesViewController.quotes = quotes
			navigationController?.pushViewController(quotesViewController, animated: true)
		}
	}
	
	@IBAction func editButtonTapped(_ sender: UIButton) {
		if let addBookViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.addBook) as? AddBookManuallyViewController {
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
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareBook))
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
		finishBookButton.round()
		finishBookButton.alignImageAndTitleVertically()
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
			try! RealmController.getBooksRealm().write {
				RealmController.getBooksRealm().create(BookModel.self, value: ["id": self.book.id, "rating": rating], update: .modified)
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
		
		readStateLabel.text = "\(book.getReadingState())"
		progressLabel.text = "\(Int(book.getPercentage()))% (Page \(book.pagesRead))"
		totalPagesLabel.text = "\(book.totalPages)"
		readTimeLabel.text = "\(book.getReadTime()) \(getReadTimeUnit())"
		progressBar.setProgress(CGFloat(book.getPercentage() / 100.0))
		
		if book.beginDate != "" {
			beginDateLabel.text = "\(book.beginDate)"
		} else {
			beginDateLabel.text = "-"
		}
		
		if book.lastReadDate != "" {
			lastReadDateLabel.text = "\(book.lastReadDate)"
		} else {
			lastReadDateLabel.text = "-"
		}
		
		if book.finishDate != "" {
			finishDateLabel.text = "\(book.finishDate)"
		} else {
			finishDateLabel.text = "-"
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
	
	@objc func shareBook() {
		let items = ["\"\(book.title)\" - \(book.author)"]
		let shareView = UIActivityViewController(activityItems: items, applicationActivities: nil)
		present(shareView, animated: true)
	}
	
	func updateBookIfTextfieldIsNotEmpty(textField: UITextField) {
		if textField.text != "" {
			if let updatedPagesRead = Int(textField.text!) {
				let date = Utils.formatDateToString(Date())
				let pagesDifference = updatedPagesRead - book.pagesRead
				if pagesDifference >= 0 {
					ReadingEntriesBrain.addPagesToEntry(with: date, pages: pagesDifference)
				} else {
					showSubstractAlert(negativeNumber: pagesDifference)
				}
				
				try! RealmController.getBooksRealm().write {
					RealmController.getBooksRealm().create(BookModel.self, value: ["id":book.id, "pagesRead": updatedPagesRead, "lastReadDate": date], update: .modified)
				}
				
				if (book.isFinished()) {
					try! RealmController.getBooksRealm().write {
						RealmController.getBooksRealm().create(BookModel.self, value: ["id":book.id, "finishDate": date], update: .modified)
						ReadingEntriesBrain.addBookToEntry(with: date, book: book)
						showBookFinishedView()
					}
				} else {
					try! RealmController.getBooksRealm().write {
						RealmController.getBooksRealm().create(BookModel.self, value: ["id":book.id, "finishDate": ""], update: .modified)
					}
				}
				
				handleBookData(self.book)
			}
		}
	}
	
	func showSubstractAlert(negativeNumber: Int) {
		let date = Utils.formatDateToString(Date())
		let substractAlert = UIAlertController(title: "Negative number", message: "Do you want to substract \(abs(negativeNumber)) from your daily pages score?", preferredStyle: .alert)
		let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
			ReadingEntriesBrain.addPagesToEntry(with: date, pages: negativeNumber)
		}
		
		let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
		
		substractAlert.addAction(yesAction)
		substractAlert.addAction(noAction)
		substractAlert.view.tintColor = .accent
		
		present(substractAlert, animated: true, completion: nil)
	}
	
	func showBookFinishedView() {
		let bookFinishedView = UIAlertController(title: "Congratulations! 🥳", message: "You have just finished a book", preferredStyle: .alert)
		bookFinishedView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		bookFinishedView.view.tintColor = .accent
		present(bookFinishedView, animated: true)
	}
	
	func showBookAlreadyFinishedView() {
		let bookFinishedView = UIAlertController(title: "Book is already finished", message: nil, preferredStyle: .alert)
		bookFinishedView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		bookFinishedView.view.tintColor = .accent
		present(bookFinishedView, animated: true)
	}
	
}

//MARK: - Extensions

extension BookDetailsViewController: AddBookManuallyViewControllerDelegate {
	func handleBookData(_ book: BookModel) {
		delegate?.editBookData(book)
		self.book = book
		updateView(book: book)
	}
}

extension BookDetailsViewController: NotesViewControllerDelegate {
	func updateNotes(with notes: String) {
		BooksBrain.editBookNotes(book: book, notes: notes)
	}
}

extension BookDetailsViewController: QuotesViewControllerDelegate {
	func updateQuotes(with quotes: List<String>) {
		BooksBrain.editBookQuotes(book: book, quotes: quotes)
	}
}
