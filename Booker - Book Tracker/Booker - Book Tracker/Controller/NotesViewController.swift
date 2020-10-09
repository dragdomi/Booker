//
//  NotesViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 08/10/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

protocol NotesViewControllerDelegate {
	func updateNotes(with notes: String)
}

class NotesViewController: UIViewController, UITextViewDelegate {
	@IBOutlet weak var textView: UITextView!
	let placeholderText = "Add your notes here..."
	var delegate: NotesViewControllerDelegate?
	var notes: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Notes"
		if notes != "" {
			textView.text = notes
			textView.textColor = .primaryText
		} else {
			textView.text = placeholderText
			textView.textColor = .secondaryText
		}
		textView.delegate = self
		textView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
	}
	
	@objc func tapDone(sender: Any) {
		self.view.endEditing(true)
	}
	
	func textViewDidChange(_ textView: UITextView) {
		if let text = textView.text {
			notes = text
			delegate?.updateNotes(with: text)
		}
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if (textView.text == placeholderText && textView.textColor == .secondaryText) {
			textView.text = ""
			textView.textColor = .primaryText
		}
		textView.becomeFirstResponder()
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if (textView.text == "") {
			textView.text = placeholderText
			textView.textColor = .secondaryText
		}
		textView.resignFirstResponder()
	}
	
}
