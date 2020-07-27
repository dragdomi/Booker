//
//  BookModel.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 14/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import Foundation
import RealmSwift

class BookModel: Object, Codable, Comparable {
	@objc dynamic var id: Int
	@objc dynamic var title: String
	@objc dynamic var author: String
	@objc dynamic var totalPages: Int
	@objc dynamic var pagesRead: Int
	@objc dynamic var beginDate: String
	@objc dynamic var finishDate: String
	@objc dynamic var lastReadDate: String
	@objc dynamic var readPercentage: Double {
		get {
			if totalPages == 0 {
				return 0
			}
			let percentage = (Double(pagesRead) / Double(totalPages)) * 100
			return percentage
		}
	}
	
	override var description: String { return "BookModel {\(id), \(title), \(author), \(totalPages), \(pagesRead), \(beginDate), \(finishDate), \(lastReadDate)}" }
	
	override static func primaryKey() -> String? {
        return "id"
    }
	
	required init() {
		self.id = 0
		self.title = "error"
		self.author = "error"
		self.totalPages = 0
		self.pagesRead = 0
		self.beginDate = ""
		self.finishDate = ""
		self.lastReadDate = ""
	}
	
	init(id: Int, title: String, author: String, totalPages: Int, pagesRead: Int, beginDate: String, finishDate: String, lastReadDate: String) {
		self.id = id
		self.title = title
		self.author = author
		self.totalPages = totalPages
		self.pagesRead = pagesRead
		self.beginDate = beginDate
		self.finishDate = finishDate
		self.lastReadDate = lastReadDate
	}
	
	
	
	enum CodingKeys: String, CodingKey {
		case id
		case title
		case author
		case totalPages
		case pagesRead
		case beginDate
		case finishDate
		case lastReadDate
	
	}
	
	static func < (lhs: BookModel, rhs: BookModel) -> Bool {
		if (lhs.lastReadDate <= rhs.lastReadDate) {
			return true
		} else {
			return false
		}
	}
	
	static func == (lhs: BookModel, rhs: BookModel) -> Bool {
		if (lhs.id == rhs.id) {
			return true
		} else {
			return false
		}
	}
}
