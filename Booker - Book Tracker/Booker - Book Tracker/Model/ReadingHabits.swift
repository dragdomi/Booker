//
//  User.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 20/07/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import Foundation

class ReadingHabits {
	private static var pagesPerDate: [String] = []
	private static var booksPerDate: [String] = []
	
	//MARK: - Pages
	
	static func addPagesToDate(pages: Int, date: String) {
		let pagesPerDateEntry = "\(date)-\(pages)"
		pagesPerDate.append(pagesPerDateEntry)
	}
	
	static func substractPagesFromDate(pages: Int, date: String) {
		var entry = "\(date)-\(pages)"
		let entryIndex = pagesPerDate.firstIndex(of: entry)
		let pagesFromDate = getPagesPerDay(date: date)
		let updatedPages = pagesFromDate - pages
		if updatedPages > 0 {
			entry = "\(date)-\(updatedPages)"
		} else {
			entry = "\(date)-\(0)"
		}
		
		if let entryIndex = entryIndex {
			pagesPerDate[entryIndex] = entry
		}
	}
	
	static func getPagesPerDate(date: String) -> Int {
		for entry in pagesPerDate {
			let index = entry.index(after: entry.firstIndex(of: "-")!)
			let datePart = entry[..<index]
			if date.count > 10 {
				let date = date[..<index]
			}
			
			if datePart == date {
				let endIndex = entry.endIndex
				let pages = entry[index..<endIndex]
				let pagesInt = Int(pages) ?? 0
				return pagesInt
			}
		}
		return 0
	}
	
	static func getPagesPerDay(date: String) -> Int {
		return getPagesPerDate(date: date)
	}
	
	static func getPagesPerMonth(month: String, year: String) -> Int {
		var pagesPerMonth = 0
		for date in pagesPerDate {
			let startIndex = date.index(date.startIndex, offsetBy: 3)
			let endIndex = date.index(date.startIndex, offsetBy: 9)
			let dateMonthAndYear = date[startIndex...endIndex]
			if dateMonthAndYear == (month + "." + year){
				pagesPerMonth += getPagesPerDay(date: date)
			}
		}
		return pagesPerMonth
	}
	
	static func getPagesPerYear(year: String) -> Int {
		var pagesPerYear = 0
		for date in pagesPerDate {
			let startIndex = date.index(date.startIndex, offsetBy: 6)
			let endIndex = date.index(date.startIndex, offsetBy: 9)
			let dateYear = date[startIndex...endIndex]
			if dateYear == (year){
				pagesPerYear += getPagesPerDay(date: date)
			}
		}
		return pagesPerYear
	}
	
	static func getTotalPagesReadNumber() -> Int {
		var totalPagesReadNumber = 0
		let books = BookBrain.getBooks()
		for book in books {
			totalPagesReadNumber += book.pagesRead
		}
		return totalPagesReadNumber
	}
	
	static func getTotalPagesNumber() -> Int {
		var totalPagesNumber = 0
		let books = BookBrain.getBooks()
		for book in books {
			totalPagesNumber += book.totalPages
		}
		return totalPagesNumber
	}
	
	static func getTotalPagesLeftNumber() -> Int {
		var totalPagesLeftNumber = 0
		let books = BookBrain.getBooks()
		for book in books {
			totalPagesLeftNumber += book.totalPages - book.pagesRead
		}
		return totalPagesLeftNumber
	}
	
	//MARK: - Books
	
	static func addBooksToDate(books: Int, date: String) {
		let booksPerDateEntry = "\(date)-\(books)"
		booksPerDate.append(booksPerDateEntry)
	}
	
	static func substractBooksFromDate(books: Int, date: String) {
		var entry = "\(date)-\(books)"
		let entryIndex = pagesPerDate.firstIndex(of: entry)
		let booksFromDate = getBooksPerDay(date: date)
		let updatedBooks = booksFromDate - books
		if updatedBooks > 0 {
			entry = "\(date)-\(updatedBooks)"
		} else {
			entry = "\(date)-\(0)"
		}
		
		if let entryIndex = entryIndex {
			booksPerDate[entryIndex] = entry
		}
	}
	
	static func getBooksPerDate(date: String) -> Int {
		for entry in booksPerDate {
			let index = entry.index(after: entry.firstIndex(of: "-")!)
			let datePart = entry[..<index]
			let date = date[..<index]
			if datePart == date {
				let endIndex = entry.endIndex
				let books = entry[index..<endIndex]
				let booksInt = Int(books) ?? 0
				return booksInt
			}
		}
		return 0
	}
	
	static func getBooksPerDay(date: String) -> Int {
		return getBooksPerDate(date: date)
	}
	
	static func getBooksPerMonth(month: String, year: String) -> Int {
		var booksPerMonth = 0
		for date in pagesPerDate {
			let startIndex = date.index(date.startIndex, offsetBy: 3)
			let endIndex = date.index(date.startIndex, offsetBy: 9)
			let dateMonthAndYear = date[startIndex...endIndex]
			if dateMonthAndYear == (month + "." + year){
				booksPerMonth += getBooksPerDay(date: date)
			}
		}
		return booksPerMonth
	}
	
	static func getBooksPerYear(year: String) -> Int {
		var booksPerYear = 0
		for date in pagesPerDate {
			let startIndex = date.index(date.startIndex, offsetBy: 6)
			let endIndex = date.index(date.startIndex, offsetBy: 9)
			let dateYear = date[startIndex...endIndex]
			if dateYear == (year){
				booksPerYear += getBooksPerDay(date: date)
			}
		}
		return booksPerYear
	}
	
	static func getBooksNotStarted() -> [BookModel] {
		var booksNotStarted = [BookModel]()
		let books = BookBrain.getBooks()
		for book in books {
			if book.pagesRead == 0 {
				booksNotStarted.append(book)
			}
		}
		return booksNotStarted
	}

	static func getBooksInProgress() -> [BookModel] {
		var booksInProgress = [BookModel]()
		let books = BookBrain.getBooks()
		for book in books {
			if book.pagesRead < book.totalPages && book.pagesRead > 0 {
				booksInProgress.append(book)
			}
		}
		return booksInProgress
	}
	
	static func getBooksRead() -> [BookModel] {
		var booksRead = [BookModel]()
		for book in BookBrain.getBooks() {
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
