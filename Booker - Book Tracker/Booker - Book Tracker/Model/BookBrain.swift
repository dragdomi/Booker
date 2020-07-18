//
//  BookBrain.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 14/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import Foundation
import Firebase

class BookBrain {
	private static let db = Firestore.firestore()
	private static var books: [BookModel] = []
	private static var userId = Firebase.Auth.auth().currentUser?.uid
	
	enum Error: Swift.Error {
		case saveFailed
		case readFailed
	}
	
	static func getDataBase() -> Firestore {
		return db
	}
	
	static func addBook(_ book: BookModel) {
		BookBrain.books.insert(book, at: 0)
	}
	
	static func getBooks() -> [BookModel] {
		return books
	}
	
	static func getUserId() -> String? {
		return userId
	}
	
	static func setUserId(_ userId: String?) {
		self.userId = userId
	}
	
	static func editBookData(oldBookData: BookModel, newBookData: BookModel) {
		var index = 0
		for book in BookBrain.books {
			if book == oldBookData {
				BookBrain.books[index] = newBookData
				break
			}
			index += 1
		}
	}
	
	static func saveBooks() {
		for book in BookBrain.books {
			let bookDocument = BookBrain.db.collection(Constants.FStore.usersCollectionName + "/" + userId! + "/" + Constants.FStore.collectionName).document("book" + String(book.id))
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
	}
	
	static func loadBooks() {
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
			let finishDate = data[Constants.FStore.finishDate] as? String {
			
			let book = BookModel(id: id,
								 title: title,
								 author: author,
								 totalPages: totalPages,
								 pagesRead: pagesRead,
								 beginDate: beginDate,
								 finishDate: finishDate)
			
			addBook(book)
			
		}
	}
}
