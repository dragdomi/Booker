//
//  User.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 20/07/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import Foundation

class ReadingHabits {
	
	//MARK: - Pages
	
	static func getTotalPagesReadNumber() -> Int {
		var totalPagesReadNumber = 0
		let books = BooksBrain.getBooks()
		for book in books {
			totalPagesReadNumber += book.pagesRead
		}
		return totalPagesReadNumber
	}
	
	static func getTotalPagesNumber() -> Int {
		var totalPagesNumber = 0
		let books = BooksBrain.getBooks()
		for book in books {
			totalPagesNumber += book.totalPages
		}
		return totalPagesNumber
	}
	
	static func getTotalPagesLeftNumber() -> Int {
		var totalPagesLeftNumber = 0
		let books = BooksBrain.getBooks()
		for book in books {
			totalPagesLeftNumber += book.totalPages - book.pagesRead
		}
		return totalPagesLeftNumber
	}
	
	//MARK: - Books
	
	static func getBooksNotStarted() -> [BookModel] {
		var booksNotStarted = [BookModel]()
		let books = BooksBrain.getBooks()
		for book in books {
			if book.pagesRead == 0 {
				booksNotStarted.append(book)
			}
		}
		return booksNotStarted
	}

	static func getBooksInProgress() -> [BookModel] {
		var booksInProgress = [BookModel]()
		let books = BooksBrain.getBooks()
		for book in books {
			if book.pagesRead < book.totalPages && book.pagesRead > 0 {
				booksInProgress.append(book)
			}
		}
		return booksInProgress
	}
	
	static func getBooksRead() -> [BookModel] {
		var booksRead = [BookModel]()
		for book in BooksBrain.getBooks() {
			if book.pagesRead == book.totalPages {
				booksRead.append(book)
			}
		}
		return booksRead
	}
	
	static func getBooksNotStartedNumber() -> Int {
		return getBooksNotStarted().count
	}
	
	static func getBooksInProgressNumber() -> Int {
		return getBooksInProgress().count
	}
	
	static func getBooksReadNumber() -> Int {
		return getBooksRead().count
	}
}
