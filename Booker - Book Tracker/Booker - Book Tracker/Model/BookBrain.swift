//
//  BookBrain.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 14/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import Foundation
import Firebase
import RealmSwift

class BookBrain {
	private static let realm = try! Realm()
	private static let db = Firestore.firestore()
	private static var books: [BookModel] = []
	private static var userId = Firebase.Auth.auth().currentUser?.uid
	
	enum Error: Swift.Error {
		case saveFailed
		case readFailed
	}
	
	static func getRealm() -> Realm {
		return realm
	}
	
	static func getDataBase() -> Firestore {
		return db
	}
	
	static func getUserId() -> String? {
		return userId
	}
	
	static func setUserId(_ userId: String?) {
		self.userId = userId
	}
	
	//MARK: - Books functions
	
	static func addBook(_ book: BookModel) {
		try! realm.write {
			realm.add(book)
		}
		loadBooksFromRealm()
	}
	
	static func deleteBook(_ book: BookModel) {
		try! realm.write {
			realm.delete(book)
		}
		loadBooksFromRealm()
	}
	
	static func getBooks() -> [BookModel] {
		return books
	}
	
	static func searchBooks(_ keyword: String) -> [BookModel] {
		if keyword == "" {
			return books
		}
		
		var foundBooks = [BookModel]()
		for book in books {
			if book.author.lowercased().contains(keyword.lowercased()) || book.title.lowercased().contains(keyword.lowercased()) {
				foundBooks.append(book)
			}
		}
		return foundBooks
	}
	
	static func getBooksFiltered(by filter: String) -> [BookModel] {
		switch filter {
		case "finished":
			return ReadingInfo.booksRead
			
		case "inProgress":
			return ReadingInfo.booksInProgress
			
		case "notStarted":
			return ReadingInfo.booksNotStarted
			
		default:
			return books
		}
	}
	
	static func getBooksSorted(by order: String) -> [BookModel] {
		switch order {
		case "title":
			return books.sorted {
				$0.title < $1.title
			}
			
		case "author":
			return books.sorted {
				$0.author < $1.author
			}
			
		case "progress":
			return books.sorted {
				$0.readPercentage < $1.readPercentage
			}
			
		case "beginDate":
			return books.sorted {
				$0.beginDate < $1.beginDate
			}
			
		case "finishDate":
			return books.sorted {
				$0.finishDate < $1.finishDate
			}
			
		default:
			return books
		}
	}
	
	static func editBookData(_ editedBook: BookModel) {
		try! realm.write {
			realm.add(editedBook, update: .modified)
		}
		loadBooksFromRealm()
	}
	
	//MARK: - Realm
	
	static func saveBooksToRealm() {
		try! realm.write {
			realm.deleteAll()
			for book in books {
				realm.add(book)
			}
		}
	}
	
	static func loadBooksFromRealm() {
		books.removeAll()
		let loadedBooks = realm.objects(BookModel.self)
		print(loadedBooks)
		for book in loadedBooks {
			books.append(book)
		}
	}
	
	//MARK: - Firestore
	
	static func saveBooksToFirestore() {
		for book in BookBrain.books {
			let bookDocument = BookBrain.db.collection(Constants.FStore.usersCollectionName + "/" + userId! + "/" + Constants.FStore.collectionName).document("book" + String(book.id))
			bookDocument.setData([
				Constants.FStore.id: book.id,
				Constants.FStore.title: book.title,
				Constants.FStore.author: book.author,
				Constants.FStore.totalPages: book.totalPages,
				Constants.FStore.pagesRead: book.pagesRead,
				Constants.FStore.beginDate: book.beginDate,
				Constants.FStore.finishDate: book.finishDate,
				Constants.FStore.lastReadDate: book.lastReadDate
			])
		}
	}
	
	static func loadBooksFromFirestore() {
		BookBrain.books.removeAll()
		BookBrain.db.collection(Constants.FStore.usersCollectionName + "/" + userId! + "/" + Constants.FStore.collectionName)
			.order(by: Constants.FStore.title)
			.addSnapshotListener { (querySnapshot, error) in
				retrieveData(querySnapshot, error as? BookBrain.Error)
		}
	}
	
	private static func retrieveData(_ querySnapshot: QuerySnapshot?, _ error: Error?) {
		if let e = error {
			print("There was an issue retrieving data from Firestore \(e)")
		} else {
			getSnapshotDocuments(querySnapshot)
		}
	}
	
	private static func getSnapshotDocuments(_ querySnapshot: QuerySnapshot?) {
		if let snapshotDocuments = querySnapshot?.documents {
			getDataFromSnapshotDocuments(snapshotDocuments)
		}
	}
	
	private static func getDataFromSnapshotDocuments(_ snapshotDocuments: [QueryDocumentSnapshot]){
		for doc in snapshotDocuments {
			let data = doc.data()
			getBookInfoFromData(data)
		}
	}
	
	private static func getBookInfoFromData(_ data: [String : Any]) {
		if let id = data[Constants.FStore.id] as? Int,
			let title = data[Constants.FStore.title] as? String,
			let author = data[Constants.FStore.author] as? String,
			let totalPages = data[Constants.FStore.totalPages] as? Int,
			let pagesRead = data[Constants.FStore.pagesRead] as? Int,
			let beginDate = data[Constants.FStore.beginDate] as? String,
			let finishDate = data[Constants.FStore.finishDate] as? String,
			let lastReadDate = data[Constants.FStore.lastReadDate] as? String {
			
			let book = BookModel(id: id,
								 title: title,
								 author: author,
								 totalPages: totalPages,
								 pagesRead: pagesRead,
								 beginDate: beginDate,
								 finishDate: finishDate,
								 lastReadDate: lastReadDate)
			
			BookBrain.books.insert(book, at: 0)
		}
	}
}
