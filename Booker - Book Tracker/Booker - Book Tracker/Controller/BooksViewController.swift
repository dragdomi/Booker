//
//  ViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 14/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

// TODO: Make loading Date from database work.

import UIKit
import Firebase

class BooksViewController: UITableViewController, AddBookViewControllerDelegate, BookDetailsViewControllerDelegate {
	let db = BookBrain.getDataBase()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		reloadTableViewDataAsync()
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.hidesBackButton = true
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "···", style: .done, target: self, action: #selector(showMenu))
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBookButton))
		
		title = "My books"
		
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 70
		tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
		BookBrain.setUserId(Firebase.Auth.auth().currentUser?.uid)
	}
	
	//MARK: - Interactions
	@objc func showMenu() {
		let menuView = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		
		let showReadingHabits = UIAlertAction(title: "Reading Habits", style: .default) { _ in
			if let readingHabitsViewController = self.storyboard?.instantiateViewController(identifier: Constants.ViewControllers.readingHabits) as? ReadingHabitsViewController {
				self.navigationController?.pushViewController(readingHabitsViewController, animated: true)
			}
		}
		
		menuView.addAction(showReadingHabits)
		menuView.view.tintColor = UIColor(named: "Color4")
		
		present(menuView, animated: true, completion: nil)
	}
	
	@objc func addBookButton() {
		if let addBookViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.addBook) as? AddBookViewController {
			addBookViewController.delegate = self
			navigationController?.pushViewController(addBookViewController, animated: true)
		}
	}
	
	//MARK: - Table View methods
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return BookBrain.getBooks().count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let book = BookBrain.getBooks()[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! BookCell
		
		cell.titleLabel.text = book.title
		cell.authorLabel.text = book.author
		cell.percentageLabel.text = "\(Int(book.readPercentage))%"
		cell.dateLabel.text = book.lastReadDate
		cell.progressBar.progress = Float(book.readPercentage/100)
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let bookDetailsViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.bookDetails) as? BookDetailsViewController {
			bookDetailsViewController.book = BookBrain.getBooks()[indexPath.row]
			bookDetailsViewController.delegate = self
			self.navigationController?.pushViewController(bookDetailsViewController, animated: true)
		}
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 5
	}
	
	//MARK: - Delegate methods
	
	func handleBookData(_ book: BookModel) {
		var book = book
		var takenIds = [Int]()
		for book in BookBrain.getBooks() {
			takenIds.append(book.id)
		}
		
		for number in 1...(takenIds.count + 1) {
			if !takenIds.contains(number) {
				book.id = number
			}
		}
		BookBrain.addBook(book)
		reloadTableViewDataAsync()
	}
	
	func editBookData(oldBook: BookModel, newBook: BookModel) {
		BookBrain.editBookData(oldBookData: oldBook, newBookData: newBook)
		reloadTableViewDataAsync()
	}
	
	func reloadTableViewDataAsync() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
}

//MARK: - Extensions
