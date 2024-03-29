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
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBookButtonTapped))
		tabBarItem.image = UIImage(systemName: "books.vertical")
		
		setupSearchController()
		//		setupHeader()
		
		title = "Books"
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
		books = BooksBrain.getBooks()
		books = BooksBrain.getBooksSorted(books: books, by: self.sort)
		booksCopy = books
		searchController.searchBar.text = ""
		reloadTableViewDataAsync()
	}
	
	func reloadBooks(searchBy keyword: String) {
		let foundBooks = BooksBrain.searchBooks(books: books, by: keyword)
		if !keyword.isEmpty {
			books = foundBooks
		} else {
			books = booksCopy
		}
		books = BooksBrain.getBooksSorted(books: books, by: self.sort)
		reloadTableViewDataAsync()
	}
	
	func reloadBooks(filterBy filter: String) {
		books = BooksBrain.getBooksFiltered(books: books, by: filter)
		books = BooksBrain.getBooksSorted(books: books, by: self.sort)
		booksCopy = books
		searchController.searchBar.text = ""
		reloadTableViewDataAsync()
	}
	
	func reloadBooks(sortBy sort: String) {
		self.sort = sort
		books = BooksBrain.getBooksSorted(books: books, by: self.sort)
		booksCopy = books
		reloadTableViewDataAsync()
	}
	
	//MARK: - Interactions
	
	func filterContentForSearchText(_ searchText: String) {
		self.searchText = searchText
		reloadBooks(searchBy: searchText)
	}
	
	@objc func addBookButtonTapped() {
		let addBookMenu = UIAlertController(title: "Add Book", message: nil, preferredStyle: .alert)
		let scanBarcode = UIAlertAction(title: "Scan Barcode", style: .default, handler: nil)
		let searchOnline = UIAlertAction(title: "Search Online", style: .default, handler: nil)
		let addBookManually = UIAlertAction(title: "Add Manually", style: .default) { _ in
			self.addBookManually()
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		addBookMenu.addAction(scanBarcode)
		addBookMenu.addAction(searchOnline)
		addBookMenu.addAction(addBookManually)
		addBookMenu.addAction(cancel)
		
		addBookMenu.view.tintColor = UIColor.accent
		
		present(addBookMenu, animated: true, completion: nil)
		
	}
	
	func addBookManually() {
		if let addBookViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.addBook) as? AddBookManuallyViewController, let addBookViewNavigationController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.addBookNavigation) as? AddBookManuallyNavigationController {
			addBookViewController.delegate = self
			addBookViewController.bookID = getFreeBookID()
			addBookViewController.title = "Add Book"
			addBookViewNavigationController.pushViewController(addBookViewController, animated: true)
			navigationController?.present(addBookViewNavigationController, animated: true, completion: nil)
		}
	}
	
	func getFreeBookID() -> Int {
		var takenIDs: [Int] = []
		var freeID = 0
		for book in BooksBrain.getBooks() {
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
		BooksBrain.addBook(book)
		reloadBooks()
		reloadTableViewDataAsync()
	}
	
	func editBookData(_ editedBook: BookModel) {
		BooksBrain.editBookData(editedBook)
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
		
		cell.progressBar.setProgress(BooksBrain.getBookProgress(book)) 
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
		if let bookDetailsViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.bookDetails) as? BookDetailsViewController, let bookDetailsViewNavigationController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.bookDetailsNavigation) as? BookDetailsViewNavigationController {
			let book = books[indexPath.row]
			bookDetailsViewController.book = book
			bookDetailsViewController.delegate = self
			bookDetailsViewController.title = book.title
			bookDetailsViewNavigationController.pushViewController(bookDetailsViewController, animated: true)
			self.navigationController?.present(bookDetailsViewNavigationController, animated: true, completion: nil)
		}
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let deleteAlert = UIAlertController(title: "Warning", message: "Are you sure you want to delete '\(books[indexPath.row].title)' from your books?", preferredStyle: .alert)
			let deleteAction = UIAlertAction(title: "Yes", style: .destructive) {_ in
				BooksBrain.deleteBook(self.books[indexPath.row])
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
