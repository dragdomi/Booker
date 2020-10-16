//
//  AddBookViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 14/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

protocol AddBookManuallyViewControllerDelegate {
	func handleBookData(_ book: BookModel)
}

class AddBookManuallyViewController: UIViewController {
	@IBOutlet weak var coverImageView: UIView!
	@IBOutlet weak var coverImage: UIImageView!
	@IBOutlet weak var coverImageButton: UIButton!
	@IBOutlet weak var bookTitleTextField: UITextField!
	@IBOutlet weak var bookAuthorTextField: UITextField!
	@IBOutlet weak var totalPagesTextField: UITextField!
	@IBOutlet weak var pagesReadTextField: UITextField!
	@IBOutlet weak var dateSegmentedControl: UISegmentedControl!
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var addBookButton: UIButton!
	var delegate: AddBookManuallyViewControllerDelegate?
	var imagePicker: ImagePicker!
	var bookID: Int?
	var bookCover: String?
	var bookTitle: String?
	var bookAuthor: String?
	var bookTotalPages: Int?
	var bookPagesRead: Int?
	var beginDate: Date?
	var finishDate: Date?
	var isFinished: Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Add Book Manually"
		self.imagePicker = ImagePicker(presentationController: self, delegate: self)
		
		if let safeBookCover = bookCover {
			coverImage.image = ImageManager.retrieveImage(forKey: safeBookCover)
		} 
		
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
		
		coverImageView.round()
		bookTitleTextField.round()
		bookAuthorTextField.round()
		pagesReadTextField.round()
		totalPagesTextField.round()
		coverImageButton.round()
		coverImage.round()
		datePicker.round()
		
		addBookButton.setTitleColor(.secondaryText, for: .disabled)
		addBookButton.isEnabled = false
		
		activateButton()
		checkIfFinished()
	}
	
	func configureViewWithShadow(_ view: UIView) {
		view.round()
	}
	
	func configureViewWithNoShadow(_ view: UIView) {
		view.layer.cornerRadius = 10
	}
	
	@IBAction func coverImageButtonTapped(_ sender: UIButton) {
		self.imagePicker.present(from: sender)
	}
	
	@IBAction func textFieldChanged(_ sender: UITextField) {
		if let senderText = sender.text {
			switch sender.tag {
			case 0:
				bookTitle = senderText
			case 1:
				bookAuthor = senderText
			case 2:
				if let senderInt = Int(senderText) {
					bookTotalPages = senderInt
				} else {
					bookTotalPages = nil
				}
			case 3:
				if let senderInt = Int(senderText) {
					bookPagesRead = senderInt
				} else {
					bookPagesRead = nil
				}
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
		if (bookTitle != "") && (bookAuthor != "") && (bookTotalPages != nil) && (bookPagesRead != nil) {
			addBookButton.isEnabled = true
		} else {
			addBookButton.isEnabled = false
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
			saveImage(self.coverImage.image!)
			createBookModel(
				id: bookID,
				cover: bookCover,
				title: bookTitle,
				author: bookAuthor,
				totalPages: bookTotalPages,
				pagesRead: bookPagesRead,
				beginDate: beginDate,
				finishDate: finishDate
			)
			navigationController?.popViewController(animated: true)
		}
	}
	
	func showAlert(title: String, message: String) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		present(ac, animated: true)
		ac.view.tintColor = .accent
	}
	
	func createBookModel(id: Int?, cover: String?, title: String?, author: String?, totalPages: Int?, pagesRead: Int?, beginDate: Date?, finishDate: Date?) {
		
		if let id = id,
		   let cover = cover,
		   let title = bookTitle,
		   let author = bookAuthor,
		   let totalPages = bookTotalPages,
		   let pagesRead = bookPagesRead {
			let beginDateString = Utils.formatDateToString(beginDate ?? Date())
			var finishDateString = Utils.formatDateToString(finishDate)
			if isFinished {
				finishDateString = Utils.formatDateToString(finishDate ?? Date())
			}
			
			let book = BookModel(id: id,
								 cover: cover,
								 title: title,
								 author: author,
								 totalPages: totalPages,
								 pagesRead: pagesRead,
								 beginDate: beginDateString,
								 finishDate: finishDateString)
			
			delegate?.handleBookData(book)
		}
	}
	
	func saveImage(_ image: UIImage) {
		self.bookCover = "book\(bookID!)_coverImage"
		ImageManager.store(image: image, forKey: self.bookCover!)
	}
	
	func cropImage(image: UIImage, rect: CGRect, scale: CGFloat) -> UIImage? {
//		UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.size.width / scale, height: rect.size.height / scale), true, 0.0)
//		image.draw(at: CGPoint(x: -rect.origin.x / scale, y: -rect.origin.y / scale))
//		let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
//		UIGraphicsEndImageContext()
//		return croppedImage
		return image
	}
}

extension AddBookManuallyViewController: ImagePickerDelegate {
	func didSelect(image: UIImage?) {
		if let image = image {
			self.coverImage.image = image
		} 
	}
}

