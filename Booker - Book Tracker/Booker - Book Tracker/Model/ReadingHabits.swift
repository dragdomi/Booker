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
	
	static func getPagesPerDateDictionary() -> [String: Int] {
		var pagesPerDateDictionary = [String: Int]()
		for entry in pagesPerDate {
			guard let date = getValueFromEntry(valueType: "dmy", entry: entry)
			else {
				print("Failed to extract date from entry")
				return [String: Int]()
			}
			
			guard let number = getValueFromEntry(valueType: "n", entry: entry)
			else {
				print("Failed to extract number from entry")
				return [String: Int]()
			}
			
			guard let pages = Int(number)
			else {
				print("Failed to convert number value to Int")
				return [String: Int]()
			}
			
			pagesPerDateDictionary[date] = pages
		}
		return pagesPerDateDictionary
	}
	
	static func addPagesToDate(pages: Int, date: String) {
		let pagesPerDateEntry = "\(date)-\(pages)"
		pagesPerDate.append(pagesPerDateEntry)
	}
	
	static func modifyPagesPerDate(pages: Int, date: String) {
		guard let entry = getPagesEntryWithDate(date)
		else {
			print("Failed to get pages entry with date")
			return
		}
		
		var modifiedEntry = String()
		let entryIndex = pagesPerDate.firstIndex(of: entry)
		let pagesFromEntry = getPagesPerDay(entry: entry)
		let updatedPages = pagesFromEntry + pages
		
		if updatedPages > 0 {
			modifiedEntry = "\(date)-\(updatedPages)"
		} else {
			modifiedEntry = "\(date)-\(0)"
		}
		
		if let entryIndex = entryIndex {
			pagesPerDate[entryIndex] = modifiedEntry
		}
	}
	
	static func getPagesPerDate(entry: String) -> Int {
		if let value = getValueFromEntry(valueType: "n", entry: entry) {
			if let pages = Int(value) {
				return pages
			}
		}
		return 0
	}
	
	static func getPagesPerDay(entry: String) -> Int {
		return getPagesPerDate(entry: entry)
	}
	
	static func getPagesPerMonth(month: String, year: String) -> Int {
		var pagesPerMonth = 0
		for date in pagesPerDate {
			guard let monthInDate = getValueFromEntry(valueType: "m", entry: date)
			else {
				print("Failed to extract month from date")
				return 0
			}
			
			guard let yearInDate = getValueFromEntry(valueType: "y", entry: date)
			else {
				print("Failed to extract year from date")
				return 0
			}
			
			let dateMonthAndYear = monthInDate + "." + yearInDate
			if dateMonthAndYear == (month + "." + year){
				pagesPerMonth += getPagesPerDay(entry: date)
			}
		}
		return pagesPerMonth
	}
	
	static func getPagesPerYear(year: String) -> Int {
		var pagesPerYear = 0
		for date in pagesPerDate {
			guard let yearInDate = getValueFromEntry(valueType: "y", entry: date)
			else {
				print("Failed to extract year from date")
				return 0
			}
			
			if yearInDate == year {
				pagesPerYear += getPagesPerDay(entry: date)
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
	
	static func getBooksPerDateDictionary() -> [String: Int] {
		var booksPerDateDictionary = [String: Int]()
		for entry in pagesPerDate {
			guard let date = getValueFromEntry(valueType: "dmy", entry: entry)
			else {
				print("Failed to extract date from entry")
				return [String: Int]()
			}
			
			guard let number = getValueFromEntry(valueType: "n", entry: entry)
			else {
				print("Failed to extract number from entry")
				return [String: Int]()
			}
			
			guard let books = Int(number)
			else {
				print("Failed to convert number value to Int")
				return [String: Int]()
			}
			
			booksPerDateDictionary[date] = books
		}
		return booksPerDateDictionary
	}
	
	static func addBooksToDate(books: Int, date: String) {
		let booksPerDateEntry = "\(date)-\(books)"
		booksPerDate.append(booksPerDateEntry)
	}
	
	static func modifyBooksPerDate(books: Int, date: String) {
		guard let entry = getBooksEntryWithDate(date)
		else {
			print("Failed to get pages entry with date")
			return
		}
		
		var modifiedEntry = String()
		let entryIndex = booksPerDate.firstIndex(of: entry)
		let booksFromEntry = getBooksPerDay(entry: entry)
		let updatedBooks = booksFromEntry + books
		
		if updatedBooks > 0 {
			modifiedEntry = "\(date)-\(updatedBooks)"
		} else {
			modifiedEntry = "\(date)-\(0)"
		}
		
		if let entryIndex = entryIndex {
			booksPerDate[entryIndex] = modifiedEntry
		}
	}
	
	static func getBooksPerDate(entry: String) -> Int {
		if let value = getValueFromEntry(valueType: "n", entry: entry) {
			if let books = Int(value) {
				return books
			}
		}
		return 0
	}
	
	static func getBooksPerDay(entry: String) -> Int {
		return getBooksPerDate(entry: entry)
	}
	
	static func getBooksPerMonth(month: String, year: String) -> Int {
		var booksPerMonth = 0
		for date in booksPerDate {
			guard let monthInDate = getValueFromEntry(valueType: "m", entry: date)
			else {
				print("Failed to extract month from date")
				return 0
			}
			
			guard let yearInDate = getValueFromEntry(valueType: "y", entry: date)
			else {
				print("Failed to extract year from date")
				return 0
			}
			
			let dateMonthAndYear = monthInDate + "." + yearInDate
			if dateMonthAndYear == (month + "." + year){
				booksPerMonth += getPagesPerDay(entry: date)
			}
		}
		return booksPerMonth
	}
	
	static func getBooksPerYear(year: String) -> Int {
		var booksPerYear = 0
		for date in booksPerDate {
			guard let yearInDate = getValueFromEntry(valueType: "y", entry: date)
			else {
				print("Failed to extract year from date")
				return 0
			}
			
			if yearInDate == year {
				booksPerYear += getPagesPerDay(entry: date)
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
	
	//MARK: - Entries
	
	private static func getValueFromEntry(valueType: String, entry: String) -> String? {
		var startIndex: String.Index?
		var endIndex: String.Index?
		switch valueType {
		case "d":
			startIndex = entry.startIndex
			endIndex = entry.index(entry.startIndex, offsetBy: 2)
		case "m":
			startIndex = entry.index(entry.startIndex, offsetBy: 3)
			endIndex = entry.index(entry.startIndex, offsetBy: 5)
		case "y":
			startIndex = entry.index(entry.startIndex, offsetBy: 6)
			endIndex = entry.index(entry.startIndex, offsetBy: 10)
		case "n":
			startIndex = entry.index(entry.startIndex, offsetBy: 11)
			endIndex = entry.endIndex
		case "dmy":
			startIndex = entry.startIndex
			endIndex = entry.index(entry.startIndex, offsetBy: 10)
		default:
			startIndex = nil
			endIndex = nil
		}
		
		if let startIndex = startIndex, let endIndex = endIndex {
			let valueSubString = entry[startIndex..<endIndex]
			let value = String(valueSubString)
			return value
		} else {
			return nil
		}
	}

	private static func getPagesEntryWithDate(_ date: String) -> String? {
		for entry in pagesPerDate {
			if getValueFromEntry(valueType: "dmy", entry: entry) == date {
				return entry
			}
		}
		
		return nil
	}
	
	private static func getBooksEntryWithDate(_ date: String) -> String? {
		for entry in booksPerDate {
			if getValueFromEntry(valueType: "dmy", entry: entry) == date {
				return entry
			}
		}
		
		return nil
	}
}
