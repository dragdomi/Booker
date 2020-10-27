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
