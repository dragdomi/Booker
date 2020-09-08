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

class BooksViewController: UIViewController, AddBookViewControllerDelegate, BookDetailsViewControllerDelegate {
	var searchController = UISearchController()
	var books = [BookModel]()
	
	@IBOutlet weak var tableView: UITableView!
	
	override func viewWillAppear(_ animated: Bool) {
		if let index = self.tableView.indexPathForSelectedRow {
			self.tableView.deselectRow(at: index, animated: true)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		BookBrain.loadBooksFromRealm()
		refreshBooks()
		reloadTableViewDataAsync()
		setupUI()
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(UINib(nibName: Constants.cellNibName, bundle: Bundle.main), forCellReuseIdentifier: Constants.cellIdentifier)
		tableView.register(UINib(nibName: Constants.headerIdentifier, bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: Constants.headerIdentifier)
		
		
		//		BookBrain.setUserId(Firebase.Auth.auth().currentUser?.uid)
	}
	
	func setupUI() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.hidesBackButton = true
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "···", style: .done, target: self, action: #selector(showMenu))
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBookButton))
		
		setupSearchController()
		setupHeader()
		
		title = "My Books"
	}
	
	func setupSearchController() {
		let controller = UISearchController(searchResultsController: nil)
		controller.searchResultsUpdater = self
		controller.searchBar.sizeToFit()
		controller.obscuresBackgroundDuringPresentation = false
		controller.hidesNavigationBarDuringPresentation = true
		controller.searchBar.placeholder = "Search books by keyword"
		controller.searchBar.searchTextField.backgroundColor = UIColor(named: "Color1")
		
		searchController = controller
		navigationItem.searchController = searchController
//		searchController.searchBar.searchBarStyle = .minimal
		
		
	}
	
	func setupHeader() {
		let header = BooksViewHeader()
		tableView.tableHeaderView = header
	}
	
	func refreshBooks() {
		books = BookBrain.getBooks()
	}
	
	func refreshBooks(keyword: String) {
		books = BookBrain.searchBooks(keyword)
	}
	
	func refreshBooks(filter: String) {
		books = BookBrain.getBooksFiltered(by: filter)
	}
	
	//MARK: - Interactions
	
	func filterContentForSearchText(_ searchText: String) {
		books = BookBrain.searchBooks(searchText)
		reloadTableViewDataAsync()
	}
	
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
		
		let filterBooks = UIAlertAction(title: "Filter books", style: .default) { _ in
			let filterBooksView = UIAlertController(title: "Filter books", message: "Which books do you want to see?", preferredStyle: .actionSheet)
			
			let showFinishedBooks = UIAlertAction(title: "Finished", style: .default) { action in
				self.title = "Finished books"
				self.refreshBooks(filter: "finished")
				self.reloadTableViewDataAsync()
			}
			
			let showBooksInProgress = UIAlertAction(title: "In progress", style: .default) { action in
				self.title = "Books in progress"
				self.refreshBooks(filter: "inProgress")
				self.reloadTableViewDataAsync()
			}
			
			let showBooksNotStarted = UIAlertAction(title: "Not started", style: .default) { action in
				self.title = "Books not started"
				self.refreshBooks(filter: "notStarted")
				self.reloadTableViewDataAsync()
			}
			
			let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
			
			filterBooksView.addAction(showFinishedBooks)
			filterBooksView.addAction(showBooksInProgress)
			filterBooksView.addAction(showBooksNotStarted)
			filterBooksView.addAction(cancelAction)
			filterBooksView.view.tintColor = UIColor(named: "Color4")
			self.present(filterBooksView, animated: true, completion: nil)
		}
		
		let sortBooks = UIAlertAction(title: "Sort books", style: .default) { _ in
			
		}
		
		let showAllBooks = UIAlertAction(title: "Show all books", style: .default) { _ in
			self.title = "My Books"
			self.refreshBooks()
			self.reloadTableViewDataAsync()
		}
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		menuView.addAction(showReadingHabits)
		menuView.addAction(showUserProfile)
		menuView.addAction(filterBooks)
		menuView.addAction(sortBooks)
		menuView.addAction(showAllBooks)
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
		refreshBooks()
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

extension BooksViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return books.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let book: BookModel
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! BookCell
		
		book = books[indexPath.row]
		
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
		let progress = CGFloat(book.readPercentage/100)
		cell.progressBar.setProgress(progress)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let bookDetailsViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.bookDetails) as? BookDetailsViewController {
			bookDetailsViewController.book = books[indexPath.row]
			bookDetailsViewController.delegate = self
			self.navigationController?.pushViewController(bookDetailsViewController, animated: true)
		}
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let deleteAlert = UIAlertController(title: "Warning", message: "Are you sure you want to delete '\(books[indexPath.row].title)' from your books?", preferredStyle: .alert)
			let deleteAction = UIAlertAction(title: "YES", style: .destructive) {_ in
				BookBrain.deleteBook(self.books[indexPath.row])
				self.refreshBooks()
				tableView.deleteRows(at: [indexPath], with: .fade)
			}
			
			let cancelAction = UIAlertAction(title: "NO", style: .default)
			deleteAlert.addAction(deleteAction)
			deleteAlert.addAction(cancelAction)
			deleteAlert.view.tintColor = UIColor(named: "Color4")
			self.present(deleteAlert, animated: true)
		}
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return BooksViewHeader.height
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return ""
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerIdentifier) as? BooksViewHeader {
			headerView.presenter = self
			return headerView
		} else {
			return nil
		}
	}
}

extension BooksViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		filterContentForSearchText(searchBar.text!)
	}
}
