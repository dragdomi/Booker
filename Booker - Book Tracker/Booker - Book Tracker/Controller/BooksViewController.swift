//
//  ViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 14/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

class BooksViewController: UIViewController, AddBookManuallyViewControllerDelegate, BookDetailsViewControllerDelegate {
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
		tableView.register(UINib(nibName: Constants.bookCellNibName, bundle: Bundle.main), forCellReuseIdentifier: Constants.bookCellIdentifier)
		tableView.register(UINib(nibName: Constants.booksHeaderIdentifier, bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: Constants.booksHeaderIdentifier)
		
		reloadBooks()
		setupUI()
		
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
	}
	
	func setupUI() {
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationItem.hidesBackButton = true
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "···", style: .done, target: self, action: #selector(showMenu))
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBookButtonTapped))
		
		setupSearchController()
		//		setupHeader()
		
		title = "My Books"
	}
	
	func setupSearchController() {
		let controller = UISearchController(searchResultsController: nil)
		controller.searchResultsUpdater = self
		controller.searchBar.sizeToFit()
		controller.obscuresBackgroundDuringPresentation = false
		controller.hidesNavigationBarDuringPresentation = false
		controller.searchBar.placeholder = "Search books by keyword"
		controller.searchBar.searchTextField.backgroundColor = .lightPrimary
		controller.view.tintColor = .accent
		
		searchController = controller
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
	}
	
	//	func setupHeader() {
	//		let header = BooksViewHeader()
	//		tableView.tableHeaderView = header
	//	}
	
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
		menuView.view.tintColor = .accent
		
		present(menuView, animated: true, completion: nil)
	}
	
	@objc func addBookButtonTapped() {
		let addBookMenu = UIAlertController(title: "Add Book", message: nil, preferredStyle: .alert)
		let scanBarcode = UIAlertAction(title: "Scan Barcode", style: .default, handler: nil)
		let searchOnline = UIAlertAction(title: "Search Online", style: .default, handler: nil)
		let addBookManually = UIAlertAction(title: "Add Manually", style: .default) { _ in
			self.addBookManually()
		}
		
		addBookMenu.addAction(scanBarcode)
		addBookMenu.addAction(searchOnline)
		addBookMenu.addAction(addBookManually)
		
		addBookMenu.view.tintColor = UIColor.accent
		
		present(addBookMenu, animated: true, completion: nil)
		
	}
	
	func addBookManually() {
		if let addBookViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.addBook) as? AddBookManuallyViewController {
			addBookViewController.delegate = self
			addBookViewController.bookID = getFreeBookID()
			navigationController?.pushViewController(addBookViewController, animated: true)
		}
	}
	
	func getFreeBookID() -> Int {
		var takenIDs: [Int] = []
		var freeID = 0
		for book in BookBrain.getBooks() {
			takenIDs.append(book.id)
		}
		
		for number in 1...(takenIDs.count + 1) {
			if !takenIDs.contains(number) {
				freeID = number
			}
		}
		
		return freeID
	}
	
	//MARK: - Delegate methods
	
	func handleBookData(_ book: BookModel) {
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
		
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.bookCellIdentifier, for: indexPath) as! BookCell
		
		//		let progress = CGFloat(book.getPercentage()) / 100
		
		cell.progressBar.setProgress(BookBrain.getBookProgress(book)) 
		cell.configure()
		cell.titleLabel.text = book.title
		cell.authorLabel.text = book.author
		cell.percentageLabel.text = "\(Int(book.getPercentage()))%"
		if book.lastReadDate != "" {
			cell.dateLabel.text = book.lastReadDate
		} else {
			cell.dateLabel.text = book.finishDate
		}
		if let coverImage = ImageManager.retrieveImage(forKey: book.cover) {
			cell.coverImage.image = coverImage
		} else {
			cell.coverImage.image = ImageManager.defaultBookCover
		}
		
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
			let deleteAction = UIAlertAction(title: "Yes", style: .destructive) {_ in
				BookBrain.deleteBook(self.books[indexPath.row])
				self.reloadBooks()
				tableView.deleteRows(at: [indexPath], with: .fade)
			}
			
			let cancelAction = UIAlertAction(title: "No", style: .default)
			deleteAlert.addAction(deleteAction)
			deleteAlert.addAction(cancelAction)
			deleteAlert.view.tintColor = .accent
			self.present(deleteAlert, animated: true)
		}
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return BooksViewHeader.height
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return nil
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.booksHeaderIdentifier) as? BooksViewHeader {
			headerView.presenter = self
			headerView.updateLabel()
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
