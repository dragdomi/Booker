//
//  QuotesViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 09/10/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit
import RealmSwift

protocol QuotesViewControllerDelegate {
	func updateQuotes(with quotes: List<String>)
}

class QuotesViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	var delegate: QuotesViewControllerDelegate?
	var book: BookModel?
	var quotes: [String] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(UINib(nibName: Constants.quoteCellNibName, bundle: Bundle.main), forCellReuseIdentifier: Constants.quoteCellIdentifier)
		tableView.register(UINib(nibName: Constants.quotesHeaderIdentifier, bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: Constants.quotesHeaderIdentifier)
		setupUI()
	}
	
	func setupUI() {
		if let bookTitle = book?.title {
			title = "\"\(bookTitle)\""
		} else {
			title = ""
		}
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddQuoteView))
//		setupHeader()
	}
	
//	func setupHeader() {
//		let header = QuotesViewHeader()
//		tableView.tableHeaderView = header
//		header.updateLabel()
//	}
	
	func updateUI() {
		
	}
	
	@objc func showAddQuoteView() {
		let addQuoteView = UIAlertController(title: "Add Quote", message: nil, preferredStyle: .alert)
		addQuoteView.addTextField(configurationHandler: { textField in
			textField.placeholder = "Quote"
			textField.keyboardType = .default
			textField.autocapitalizationType = .sentences
		})
		
		let confirmAction = UIAlertAction(title: "Done", style: .default) { [weak addQuoteView] _ in
			guard let addQuoteView = addQuoteView, let textField = addQuoteView.textFields?.first else { return }
			self.addQuoteIfTextFieldIsNotEmpty(textField: textField)
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		addQuoteView.addAction(confirmAction)
		addQuoteView.addAction(cancelAction)
		addQuoteView.view.tintColor = .accent
		
		present(addQuoteView, animated: true, completion: nil)
	}
	
	func addQuoteIfTextFieldIsNotEmpty(textField: UITextField) {
		if textField.text != "" {
			if let quote = textField.text {
				quotes.append(quote)
				let quotesList = Utils.getListFromArray(quotes)
				delegate?.updateQuotes(with: quotesList)
			}
		}
		tableView.reloadData()
	}
	
	func editQuote(quoteID: Int, textField: UITextField) {
		if textField.text != "" {
			if let quote = textField.text {
				quotes[quoteID] = quote
				let quotesList = Utils.getListFromArray(quotes)
				delegate?.updateQuotes(with: quotesList)
			}
		}
	}
}

extension QuotesViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return quotes.count
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let editQuoteView = UIAlertController(title: "Edit Quote", message: nil, preferredStyle: .alert)
		editQuoteView.addTextField(configurationHandler: { textField in
			textField.text = self.quotes[indexPath.row]
			textField.placeholder = "Quote"
			textField.keyboardType = .default
		})
		
		let confirmAction = UIAlertAction(title: "Done", style: .default) { [weak editQuoteView] _ in
			guard let editQuoteView = editQuoteView, let textField = editQuoteView.textFields?.first else { return }
			self.editQuote(quoteID: indexPath.row, textField: textField)
			tableView.reloadData()
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		editQuoteView.addAction(confirmAction)
		editQuoteView.addAction(cancelAction)
		editQuoteView.view.tintColor = .accent
		
		present(editQuoteView, animated: true, completion: nil)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.quoteCellIdentifier, for: indexPath) as! QuoteCell
		cell.quoteLabel.text = quotes[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			quotes.remove(at: indexPath.row)
			let quotesList = Utils.getListFromArray(quotes)
			delegate?.updateQuotes(with: quotesList)
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return QuotesViewHeader.height
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return nil
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.quotesHeaderIdentifier) as? QuotesViewHeader {
			headerView.presenter = self
			headerView.updateLabel()
			return headerView
		} else {
			return nil
		}
	}
}
