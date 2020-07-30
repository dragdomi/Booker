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
	override func viewDidLoad() {
		super.viewDidLoad()
		BookBrain.loadBooksFromRealm()
		reloadTableViewDataAsync()
		setupUI()
		
		tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
//		BookBrain.setUserId(Firebase.Auth.auth().currentUser?.uid)
	}
	
	func setupUI() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.hidesBackButton = true
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "···", style: .done, target: self, action: #selector(showMenu))
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBookButton))
		
		title = "My books"
		
//		tableView.rowHeight = UITableView.automaticDimension
	}
	
	//MARK: - Interactions
	@objc func showMenu() {
		let menuView = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		
		let showReadingHabits = UIAlertAction(title: "Reading Habits", style: .default) { _ in
			if let readingHabitsViewController = self.storyboard?.instantiateViewController(identifier: Constants.ViewControllers.readingHabits) as? ReadingHabitsViewController {
				self.navigationController?.pushViewController(readingHabitsViewController, animated: true)
			}
		}
		
		let showUserProfile = UIAlertAction(title: "My Profile", style: .default) { _ in
			if let userProfileViewController = self.storyboard?.instantiateViewController(identifier: Constants.ViewControllers.userProfile) as? UserProfileViewController {
				self.navigationController?.pushViewController(userProfileViewController, animated: true)
			}
		}
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		menuView.addAction(showReadingHabits)
		menuView.addAction(showUserProfile)
		menuView.addAction(cancel)
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
		
		cell.cellView.layer.cornerRadius = 10
		cell.cellView.layer.shadowPath =  UIBezierPath(roundedRect: cell.cellView.bounds, cornerRadius: cell.cellView.layer.cornerRadius).cgPath
		cell.cellView.layer.shadowRadius = 1
		cell.cellView.layer.shadowOffset = .zero
		cell.cellView.layer.shadowOpacity = 0.5
		
		cell.selectedBackgroundView?.backgroundColor = UIColor(named: "Color1")
		
		cell.titleLabel.text = book.title
		cell.authorLabel.text = book.author
		cell.percentageLabel.text = "\(Int(book.readPercentage))%"
		cell.dateLabel.text = book.lastReadDate
		cell.progressBar.setProgress(CGFloat(book.readPercentage/100))
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let bookDetailsViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.bookDetails) as? BookDetailsViewController {
			bookDetailsViewController.book = BookBrain.getBooks()[indexPath.row]
			bookDetailsViewController.delegate = self
			self.navigationController?.pushViewController(bookDetailsViewController, animated: true)
		}
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let deleteAlert = UIAlertController(title: "Warning", message: "Are you sure you want to delete '\(BookBrain.getBooks()[indexPath.row].title)' from your books?", preferredStyle: .alert)
			let deleteAction = UIAlertAction(title: "YES", style: .destructive) {_ in
				BookBrain.deleteBook(BookBrain.getBooks()[indexPath.row])
				tableView.deleteRows(at: [indexPath], with: .fade)
			}
			let cancelAction = UIAlertAction(title: "NO", style: .default)
			deleteAlert.addAction(deleteAction)
			deleteAlert.addAction(cancelAction)
			
			deleteAlert.view.tintColor = UIColor(named: "Color4")
			self.present(deleteAlert, animated: true)
			
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
//				try! BookBrain.getRealm().write {
//					BookBrain.getRealm().create(BookModel.self, value: ["id": number], update: .modified)
//				}
				book.id = number
			}
		}
		BookBrain.addBook(book)
		print(BookBrain.getBooks())
		reloadTableViewDataAsync()
	}
	
	func editBookData(_ editedBook: BookModel) {
		BookBrain.editBookData(editedBook)
		reloadTableViewDataAsync()
	}
	
	func reloadTableViewDataAsync() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
}

//MARK: - Extensions
