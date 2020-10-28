//
//  ReadingHabitModel.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 27/10/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import Foundation
import RealmSwift

class ReadingEntryModel: Object, Codable {
	@objc dynamic var date: String
	@objc dynamic var pages: Int
	var books = List<BookModel>()
	
	func getDatePart(part: String) -> String? {
		var startIndex: String.Index?
		var endIndex: String.Index?
		
		switch part {
		case "d", "day":
			startIndex = date.startIndex
			endIndex = date.index(date.startIndex, offsetBy: 2)
		case "m", "month":
			startIndex = date.index(date.startIndex, offsetBy: 3)
			endIndex = date.index(date.startIndex, offsetBy: 5)
		case "y", "year":
			startIndex = date.index(date.startIndex, offsetBy: 6)
			endIndex = date.index(date.startIndex, offsetBy: 10)
		default:
			startIndex = nil
			endIndex = nil
		}
		
		if let startIndex = startIndex, let endIndex = endIndex {
			let dateSubString = date[startIndex..<endIndex]
			let datePart = String(dateSubString)
			return datePart
		} else {
			return nil
		}
	}
	
	override var description: String { return "ReadingHabitModel {\(date), \(pages), \(books)}" }
	
	required init() {
		self.date = ""
		self.pages = 0
		self.books = List<BookModel>()
	}
	
	init(date: String, pages: Int, books: List<BookModel>) {
		self.date = date
		self.pages = pages
		self.books = books
	}
	
	enum CodingKeys: String, CodingKey {
		case date = "date"
		case pages = "pages"
		case books = "books"
	}
	
	
	
}
