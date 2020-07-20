//
//  User.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 20/07/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import Foundation

class ReadingHabits {
	static var pagesReadNumber: Int {
		var pagesReadNumber = 0
		let books = BookBrain.getBooks()
		for book in books {
			pagesReadNumber += book.pagesRead
		}
		return pagesReadNumber
	}
	
	static var booksNotStarted: [BookModel] {
		var booksNotStarted = [BookModel]()
		let books = BookBrain.getBooks()
		for book in books {
			if book.pagesRead == 0 {
				booksNotStarted.append(book)
			}
		}
		return booksNotStarted
	}
	
	static var booksInProgress: [BookModel] {
		var booksInProgress = [BookModel]()
		let books = BookBrain.getBooks()
		for book in books {
			if book.pagesRead < book.totalPages && book.pagesRead > 0 {
				booksInProgress.append(book)
			}
		}
		return booksInProgress
	}
	
	static var booksRead: [BookModel] {
		var booksRead = [BookModel]()
		for book in booksInProgress {
			if book.pagesRead == book.totalPages {
				booksRead.append(book)
			}
		}
		return booksRead
	}
	
	static var booksNotStartedNumber: Int {
		return booksNotStarted.count
	}
	
	static var booksInProgressNumber: Int {
		return booksInProgress.count
	}
	
	static var booksReadNumber: Int {
		return booksRead.count
	}
	
	
}
