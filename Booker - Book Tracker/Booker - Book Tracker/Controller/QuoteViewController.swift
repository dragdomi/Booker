//
//  QuoteViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 14/10/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

protocol QuoteViewControllerDelegate {
	func updateQuote(quoteID: Int, with text: String)
}

class QuoteViewController: UIViewController, UITextViewDelegate {
	@IBOutlet weak var textView: UITextView!
	let placeholderText = "Add quote here..."
	var delegate: QuoteViewControllerDelegate?
	var quoteID: Int?
	var quote: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Quote"
		if quote != "" {
			textView.text = quote
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
		
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if (textView.text == placeholderText && textView.textColor == .secondaryText) {
			textView.text = ""
			textView.textColor = .primaryText
		}
		textView.becomeFirstResponder()
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if let text = textView.text, let quoteID = quoteID {
			quote = text
			delegate?.updateQuote(quoteID: quoteID, with: text)
		}
		
		if (textView.text == "") {
			textView.text = placeholderText
			textView.textColor = .secondaryText
		}
		textView.resignFirstResponder()
	}
}
