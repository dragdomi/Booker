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
	var bookBrain = BookBrain() {
		didSet {
			reloadTableViewDataAsync()
		}
	}
	let db = Firestore.firestore()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationController?.navigationBar.prefersLargeTitles = true
		
		navigationItem.hidesBackButton = true
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadBooks))
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBookButton))
		
		//tableView.dataSource = self
		
		title = "Your books"
		bookBrain.books.removeAll()
		loadBooks()
	}
	
	//MARK: - Interactions
	
	@objc func addBookButton() {
		if let addBookViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.addBook) as? AddBookViewController {
			addBookViewController.delegate = self
			navigationController?.pushViewController(addBookViewController, animated: true)
		}
	}
	
	//MARK: - Load books
	
	@objc func loadBooks() {
		bookBrain.books.removeAll()
		db.collection(Constants.FStore.collectionName)
			.order(by: Constants.FStore.title)
			.addSnapshotListener { (querySnapshot, error) in
				self.retrieveData(querySnapshot, error)
		}
	}
	
	func retrieveData(_ querySnapshot: QuerySnapshot?, _ error: Error?) {
		if let e = error {
			print("There was an issue retrieving data from Firestore \(e)")
		} else {
			getSnapshotDocuments(querySnapshot)
		}
	}
	
	func getSnapshotDocuments(_ querySnapshot: QuerySnapshot?) {
		if let snapshotDocuments = querySnapshot?.documents {
			getDataFromSnapshotDocuments(snapshotDocuments)
		}
	}
	
	func getDataFromSnapshotDocuments(_ snapshotDocuments: [QueryDocumentSnapshot]){
		for doc in snapshotDocuments {
			let data = doc.data()
			getBookInfoFromData(data)
		}
	}
	
	func getBookInfoFromData(_ data: [String : Any]) {
		if let id = data[Constants.FStore.id] as? Int,
			let title = data[Constants.FStore.title] as? String,
			let author = data[Constants.FStore.author] as? String,
			let totalPages = data[Constants.FStore.totalPages] as? Int,
			let pagesRead = data[Constants.FStore.pagesRead] as? Int,
			let beginDate = data[Constants.FStore.beginDate] as? String,
			let finishDate = data[Constants.FStore.finishDate] as? String {
			
			let book = BookModel(id: id,
								 title: title,
								 author: author,
								 totalPages: totalPages,
								 pagesRead: pagesRead,
								 beginDate: beginDate,
								 finishDate: finishDate)
			
			addBookToBooks(book)
		}
	}
	
	func addBookToBooks (_ book: BookModel) {
		bookBrain.addBook(book)
	}
	
	//MARK: - Save books
	
	func saveBookData(_ book: BookModel) {
		
		let bookDocument = db.collection(Constants.FStore.collectionName).document("book" + String(book.id))
		bookDocument.setData([
			Constants.FStore.id: book.id,
			Constants.FStore.title: book.title,
			Constants.FStore.author: book.author,
			Constants.FStore.totalPages: book.totalPages,
			Constants.FStore.pagesRead: book.pagesRead,
			Constants.FStore.beginDate: book.beginDate ,
			Constants.FStore.finishDate: book.finishDate
		])
	}
	
	func checkIfSavingFailed(_ error: Error?) {
		if let e = error {
			print("There wan an issue saving data to firestore, \(e)")
		} else {
			print("Successfully saved data")
		}
	}
	
	//MARK: - Table View methods
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return bookBrain.books.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let book = bookBrain.books[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "Book", for: indexPath)
		cell.textLabel?.text = book.title
		cell.detailTextLabel?.text = book.author
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let bookDetailsViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.bookDetails) as? BookDetailsViewController {
			bookDetailsViewController.book = bookBrain.books[indexPath.row]
			bookDetailsViewController.delegate = self
			self.navigationController?.pushViewController(bookDetailsViewController, animated: true)
		}
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			bookBrain.books.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
	
	//MARK: - Delegate methods
	
	func handleBookData(_ book: BookModel) {
		var book = book
		var takenIds = [Int]()
		for book in bookBrain.books {
			takenIds.append(book.id)
		}
		
		for number in 1...(takenIds.count + 1) {
			if !takenIds.contains(number) {
				book.id = number
			}
		}
		
		saveBookData(book)
	}
	
	func editBookData(oldBook: BookModel, newBook: BookModel) {
		bookBrain.editBookData(oldBookData: oldBook, newBookData: newBook)
//		saveBookData(newBook)
		let bookDocument = db.collection(Constants.FStore.collectionName).document("book" + String(oldBook.id))
		bookDocument.updateData([
			Constants.FStore.title: newBook.title,
			Constants.FStore.author: newBook.author,
			Constants.FStore.totalPages: newBook.totalPages,
			Constants.FStore.pagesRead: newBook.pagesRead,
			Constants.FStore.beginDate: newBook.beginDate ,
			Constants.FStore.finishDate: newBook.finishDate
		])
		loadBooks()
//		reloadTableViewDataAsync()
	}
	
	func reloadTableViewDataAsync() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
}

//MARK: - Extensions
