//
//  User.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 20/07/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import Foundation

class ReadingInfo {
	private static var pagesPerDate: [String: Int] = [:]
	
	static func addPagesToDate(pages: Int, date: String) {
		pagesPerDate[date] = pagesPerDate[date] ?? 0 + pages
	}
	
	static func getPagesPerDate(date: String) -> Int {
		return pagesPerDate[date] ?? 0
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
		for book in BookBrain.getBooks() {
			if book.pagesRead == book.totalPages {
				booksRead.append(book)
			}
		}
		return booksRead
	}
	
	static func getBooksNotStartedNumber() -> Int {
		return booksNotStarted.count
	}
	
	static func getBooksInProgressNumber() -> Int {
		return booksInProgress.count
	}
	
	static func getBooksReadNumber() -> Int {
		return booksRead.count
	}
	
	private static var totalPagesReadNumber: Int {
		var totalPagesReadNumber = 0
		let books = BookBrain.getBooks()
		for book in books {
			totalPagesReadNumber += book.pagesRead
		}
		return totalPagesReadNumber
	}
	
	private static var totalPagesNumber: Int {
		var totalPagesNumber = 0
		let books = BookBrain.getBooks()
		for book in books {
			totalPagesNumber += book.totalPages
		}
		return totalPagesNumber
	}
	
	private static var totalPagesLeftNumber: Int {
		var totalPagesLeftNumber = 0
		let books = BookBrain.getBooks()
		for book in books {
			totalPagesLeftNumber += book.totalPages - book.pagesRead
		}
		return totalPagesLeftNumber
	}
	
	static func getTotalPagesReadNumber() -> Int {
		return totalPagesReadNumber
	}
	
	static func getTotalPagesNumber() -> Int {
		return totalPagesNumber
	}
	
	static func getTotalPagesLeftNumber() -> Int {
		return totalPagesLeftNumber
	}
	
	
}