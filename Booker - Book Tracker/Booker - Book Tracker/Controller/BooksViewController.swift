//
//  ViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 14/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit
import Firebase

class BooksViewController: UIViewController, AddBookViewControllerDelegate, BookDetailsViewControllerDelegate {
	var searchController = UISearchController()
	var books: [BookModel] = []
	var booksCopy: [BookModel] = []
	var sort: String = ""
	var searchText: String?
	
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(UINib(nibName: Constants.cellNibName, bundle: Bundle.main), forCellReuseIdentifier: Constants.cellIdentifier)
		tableView.register(UINib(nibName: Constants.headerIdentifier, bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: Constants.headerIdentifier)
		
		reloadBooks()
		setupUI()
		
		//		BookBrain.setUserId(Firebase.Auth.auth().currentUser?.uid)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if let index = self.tableView.indexPathForSelectedRow {
			self.tableView.deselectRow(at: index, animated: animated)
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		navigationItem.hidesSearchBarWhenScrolling = true
		print("essa")
	}
	
	func setupUI() {
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
		controller.hidesNavigationBarDuringPresentation = false
		controller.searchBar.placeholder = "Search books by keyword"
		controller.searchBar.searchTextField.backgroundColor = UIColor(named: "Color1")
		
		searchController = controller
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
	}
	
	func setupHeader() {
		let header = BooksViewHeader()
		tableView.tableHeaderView = header
	}
	
	//MARK: - Books
	
	func reloadBooks() {
		books = BookBrain.getBooks()
		books = BookBrain.getBooksSorted(books: books, by: self.sort)
		booksCopy = books
		searchController.searchBar.text = ""
		reloadTableViewDataAsync()
	}
	
	func reloadBooks(searchBy keyword: String) {
		let foundBooks = BookBrain.searchBooks(books: books, by: keyword)
		if !keyword.isEmpty {
			books = foundBooks
		} else {
			books = booksCopy
		}
		books = BookBrain.getBooksSorted(books: books, by: self.sort)
		reloadTableViewDataAsync()
	}
	
	func reloadBooks(filterBy filter: String) {
		books = BookBrain.getBooksFiltered(books: books, by: filter)
		books = BookBrain.getBooksSorted(books: books, by: self.sort)
		booksCopy = books
		searchController.searchBar.text = ""
		reloadTableViewDataAsync()
	}
	
	func reloadBooks(sortBy sort: String) {
		self.sort = sort
		books = BookBrain.getBooksSorted(books: books, by: self.sort)
		booksCopy = books
		reloadTableViewDataAsync()
	}
	
	//MARK: - Interactions
	
	func filterContentForSearchText(_ searchText: String) {
		self.searchText = searchText
		reloadBooks(searchBy: searchText)
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
	
	//MARK: - Delegate methods
	
	func handleBookData(_ book: BookModel) {
		var takenIds: [Int] = []
		for book in BookBrain.getBooks() {
			takenIds.append(book.id)
		}
		
		for number in 1...(takenIds.count + 1) {
			if !takenIds.contains(number) {
				book.id = number
			}
		}
		
		BookBrain.addBook(book)
		reloadBooks()
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
		let book = books[indexPath.row]
		
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! BookCell
		let progress = CGFloat(book.getPercentage()/100)
		cell.progressBar.setProgress(progress)
		cell.configure()
		cell.titleLabel.text = book.title
		cell.authorLabel.text = book.author
		cell.percentageLabel.text = "\(Int(book.getPercentage()))%"
		cell.dateLabel.text = book.lastReadDate
		
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
				self.reloadBooks()
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
		if let searchBarText = searchBar.text {
			filterContentForSearchText(searchBarText)
		}
	}
}
