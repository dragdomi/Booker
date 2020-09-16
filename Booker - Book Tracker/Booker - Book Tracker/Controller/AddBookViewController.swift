//
//  AddBookViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 14/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

protocol AddBookViewControllerDelegate {
	func handleBookData(_ book: BookModel)
}

class AddBookViewController: UIViewController {
	@IBOutlet weak var coverImageView: UIView!
	@IBOutlet weak var coverImageButton: UIButton!
	@IBOutlet weak var bookTitleTextField: UITextField!
	@IBOutlet weak var bookAuthorTextField: UITextField!
	@IBOutlet weak var totalPagesTextField: UITextField!
	@IBOutlet weak var pagesReadTextField: UITextField!
	@IBOutlet weak var dateSegmentedControl: UISegmentedControl!
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var addBookButton: UIButton!
	var delegate: AddBookViewControllerDelegate?
	var bookId: Int?
	var bookTitle: String?
	var bookAuthor: String?
	var bookTotalPages: Int?
	var bookPagesRead: Int?
	var beginDate: Date?
	var finishDate: Date?
	var lastReadDate: Date?
	var isFinished: Bool = false
	
	override func viewDidLoad() {
		if let safeBookTitle = bookTitle {
			bookTitleTextField.text = safeBookTitle
		}
		
		if let safeBookAuthor = bookAuthor {
			bookAuthorTextField.text = safeBookAuthor
		}
		
		if let safeBookTotalPages = bookTotalPages {
			totalPagesTextField.text = String(safeBookTotalPages)
		}
		
		if let safeBookPagesRead = bookPagesRead {
			pagesReadTextField.text = String(safeBookPagesRead)
		}
		
		if let safeBeginDate = beginDate {
			datePicker.date = safeBeginDate
		}
		
		configureCoverImageView()
		configureCoverImageButton()
		configureTextField(bookTitleTextField)
		configureTextField(bookAuthorTextField)
		configureTextField(totalPagesTextField)
		configureTextField(pagesReadTextField)
		
		addBookButton.isEnabled = false
		activateButton()
		//		dateSwitcher.removeSegment(at: 1, animated: false)
		checkIfFinished()
	}
	
	func configureCoverImageView() {
		coverImageView.layer.cornerRadius = 10
		coverImageView.layer.shadowPath =  UIBezierPath(roundedRect: coverImageView.bounds, cornerRadius: coverImageView.layer.cornerRadius).cgPath
		coverImageView.layer.shadowRadius = 1
		coverImageView.layer.shadowOffset = .zero
		coverImageView.layer.shadowOpacity = 0.5
	}
	
	func configureCoverImageButton() {
		coverImageButton.layer.cornerRadius = 10
	}
	
	func configureTextField(_ textfield: UITextField) {
		textfield.layer.cornerRadius = 10
		textfield.layer.shadowPath =  UIBezierPath(roundedRect: textfield.bounds, cornerRadius: textfield.layer.cornerRadius).cgPath
		textfield.layer.shadowRadius = 1
		textfield.layer.shadowOffset = .zero
		textfield.layer.shadowOpacity = 0.5
	}
	
	@IBAction func coverImageButtonTapped(_ sender: UIButton) {
		let coverImageMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: nil)
		let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: nil)
		let clearPhotoAction = UIAlertAction(title: "Clear Photo", style: .destructive, handler: nil)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		coverImageMenu.addAction(takePhotoAction)
		coverImageMenu.addAction(photoLibraryAction)
		coverImageMenu.addAction(clearPhotoAction)
		coverImageMenu.addAction(cancelAction)
		coverImageMenu.view.tintColor = UIColor(named: "Color4")
		
		present(coverImageMenu, animated: true)
	}
	
	@IBAction func textFieldChanged(_ sender: UITextField) {
		if let senderText = sender.text {
			switch sender.tag {
			case 0:
				bookTitle = senderText
			case 1:
				bookAuthor = senderText
			case 2:
				if let senderInt = Int(senderText) { bookTotalPages = senderInt }
			case 3:
				if let senderInt = Int(senderText) { bookPagesRead = senderInt }
			default:
				print("Out of cases")
			}
		}
		activateButton()
		checkIfFinished()
	}
	
	func checkIfFinished() {
		if bookPagesRead == nil || bookTotalPages == nil {
			isFinished = false
		} else if bookPagesRead == bookTotalPages {
			isFinished = true
		} else {
			isFinished = false
			self.finishDate = nil
		}
		activateButton()
		updateDateSegments(isFinished: isFinished)
	}
	
	func updateDateSegments(isFinished: Bool) {
		if isFinished == false && dateSegmentedControl.numberOfSegments > 1 {
			dateSegmentedControl.removeSegment(at: 1, animated: true)
		} else if isFinished == true && dateSegmentedControl.numberOfSegments < 2 {
			dateSegmentedControl.insertSegment(withTitle: "Finish date:", at: 1, animated: true)
		}
	}
	
	@IBAction func dateSegmentedControlChanged(_ sender: UISegmentedControl) {
		if dateSegmentedControl.selectedSegmentIndex == 0 {
			pickBeginDateFromDatePicker()
		} else if dateSegmentedControl.selectedSegmentIndex == 1 {
			pickFinishDateFromDatePicker()
		}
	}
	
	func pickBeginDateFromDatePicker() {
		if let safeBeginDate = beginDate {
			datePicker.date = safeBeginDate
		} else {
			datePicker.date = Date()
		}
	}
	
	func pickFinishDateFromDatePicker() {
		if let safeFinishDate = finishDate {
			datePicker.date = safeFinishDate
		} else {
			datePicker.date = Date()
		}
	}
	
	@IBAction func dateChanged(_ sender: UIDatePicker) {
		if dateSegmentedControl.selectedSegmentIndex == 0 {
			beginDate = sender.date
		} else if dateSegmentedControl.selectedSegmentIndex == 1 {
			finishDate = sender.date
		} else {
			finishDate = nil
		}
		activateButton()
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
		super.touchesBegan(touches, with: event)
	}
	
	func activateButton() {
		if (bookTitle != nil) && (bookAuthor != nil) && (bookTitle != nil) &&
			(bookTotalPages != nil) &&
			(bookPagesRead != nil) {
			addBookButton.isEnabled = true
		}
	}
	
	@IBAction func addBookButtonPressed(_ sender: UIButton) {
		if let totalPages = bookTotalPages, let readPages = bookPagesRead  {
			checkPagesValues(totalPages, readPages)
		}
	}
	
	func checkPagesValues(_ totalPages: Int, _ readPages: Int) {
		if readPages > totalPages {
			showAlert(title: "Oops", message: "You can't read more pages than the book has.")
		} else {
			createBookModel(title: bookTitle,
							author: bookAuthor,
							totalPages: bookTotalPages,
							pagesRead: bookPagesRead,
							beginDate: beginDate,
							finishDate: finishDate,
							lastReadDate: nil
			)
			navigationController?.popViewController(animated: true)
		}
	}
	
	func showAlert(title: String, message: String) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		present(ac, animated: true)
	}
	
	func createBookModel(title: String?, author: String?, totalPages: Int?, pagesRead: Int?, beginDate: Date?, finishDate: Date?, lastReadDate: Date?) {
		
		if let title = bookTitle,
			let author = bookAuthor,
			let totalPages = bookTotalPages,
			let pagesRead = bookPagesRead {
			let beginDateString = Utils.formatDateToString(beginDate ?? Date())
			var finishDateString = Utils.formatDateToString(finishDate)
			if isFinished {
				finishDateString = Utils.formatDateToString(finishDate ?? Date())
			}
			let lastReadDate = Utils.formatDateToString(lastReadDate)
			let book = BookModel(id: bookId ?? 0,
								 title: title,
								 author: author,
								 totalPages: totalPages,
								 pagesRead: pagesRead,
								 beginDate: beginDateString,
								 finishDate: finishDateString,
								 lastReadDate: lastReadDate)
			
			delegate?.handleBookData(book)
		}
	}
}

