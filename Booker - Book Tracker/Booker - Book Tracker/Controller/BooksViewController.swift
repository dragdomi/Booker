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
	var bookBrain = BookBrain()
	let db = Firestore.firestore()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationController?.navigationBar.prefersLargeTitles = true
		
		navigationItem.hidesBackButton = true
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBookButton))
		
		//		tableView.dataSource = self
		
		title = "Your books"
		
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
	
	func loadBooks() {
		bookBrain.books = []
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
		if let title = data[Constants.FStore.title] as? String,
			let author = data[Constants.FStore.author] as? String,
			let totalPages = data[Constants.FStore.totalPages] as? Int,
			let pagesRead = data[Constants.FStore.pagesRead] as? Int,
			let beginDate = data[Constants.FStore.beginDate] as? String,
			let finishDate = data[Constants.FStore.finishDate] as? String {
			
			let book = BookModel(title: title, author: author, totalPages: totalPages, pagesRead: pagesRead, beginDate: beginDate, finishDate: finishDate)
			
			addBookToBooks(book)
		}
	}
	
	func addBookToBooks (_ book: BookModel) {
		bookBrain.addBook(book)
		reloadTableViewDataAsync()
	}
	
	//MARK: - Save books
	
	func saveBookData(_ book: BookModel) {
		
		let bookDocument = db.collection(Constants.FStore.collectionName).document(book.title)
		bookDocument.setData([
			Constants.FStore.title: book.title,
			Constants.FStore.author: book.author,
			Constants.FStore.totalPages: book.totalPages,
			Constants.FStore.pagesRead: book.pagesRead,
			Constants.FStore.beginDate: book.beginDate ,
			Constants.FStore.finishDate: book.finishDate
		])
		
//		dataBase.collection(Constants.FStore.collectionName).addDocument(data: [
//			Constants.FStore.title: book.title,
//			Constants.FStore.author: book.author,
//			Constants.FStore.totalPages: book.totalPages,
//			Constants.FStore.pagesRead: book.pagesRead,
//			Constants.FStore.beginDate: book.beginDate ,
//			Constants.FStore.finishDate: book.finishDate
//		]) { (error) in
//			self.checkIfSavingFailed(error)
//		}
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
	
	//MARK: - Delegate methods
	
	func handleBookData(_ book: BookModel) {
		//		bookBrain.addBook(book)
		saveBookData(book)
		//		let indexPath = IndexPath(row: 0, section: 0)
		//		DispatchQueue.main.async {
		//			self.tableView.insertRows(at: [indexPath], with: .automatic)
		//		}
	}
	
	func editBookData(oldBook: BookModel, newBook: BookModel) {
		bookBrain.editBookData(oldBookData: oldBook, newBookData: newBook)
		
		let bookDocument = db.collection(Constants.FStore.collectionName).document(oldBook.title)
		bookDocument.updateData([
			Constants.FStore.title: newBook.title,
			Constants.FStore.author: newBook.author,
			Constants.FStore.totalPages: newBook.totalPages,
			Constants.FStore.pagesRead: newBook.pagesRead,
			Constants.FStore.beginDate: newBook.beginDate ,
			Constants.FStore.finishDate: newBook.finishDate
		])
		loadBooks()
		reloadTableViewDataAsync()
	}
	
	func reloadTableViewDataAsync() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
}

//MARK: - Extensions
