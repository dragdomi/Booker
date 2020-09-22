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
	@objc dynamic var cover: String
	@objc dynamic var title: String
	@objc dynamic var author: String
	@objc dynamic var totalPages: Int
	@objc dynamic var pagesRead: Int
	@objc dynamic var beginDate: String
	@objc dynamic var finishDate: String
	@objc dynamic var lastReadDate: String
	
	func getPercentage() -> Float {
		if totalPages == 0 {
			return 0
		}
		let percentage = (Float(pagesRead) / Float(totalPages)) * 100
		return percentage
	}
	
	override var description: String { return "BookModel {\(id), \(title), \(author), \(totalPages), \(pagesRead), \(beginDate), \(finishDate), \(lastReadDate)}" }
	
	override static func primaryKey() -> String? {
        return "id"
    }
	
	required init() {
		self.id = 0
		self.cover = ""
		self.title = "error"
		self.author = "error"
		self.totalPages = 0
		self.pagesRead = 0
		self.beginDate = ""
		self.finishDate = ""
		self.lastReadDate = ""
	}
	
	init(id: Int, cover: String, title: String, author: String, totalPages: Int, pagesRead: Int, beginDate: String, finishDate: String, lastReadDate: String) {
		self.id = id
		self.cover = cover
		self.title = title
		self.author = author
		self.totalPages = totalPages
		self.pagesRead = pagesRead
		self.beginDate = beginDate
		self.finishDate = finishDate
		self.lastReadDate = lastReadDate
	}
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case cover = "cover"
		case title = "title"
		case author = "author"
		case totalPages = "totalPages"
		case pagesRead = "pagesRead"
		case beginDate = "beginDate"
		case finishDate = "finishDate"
		case lastReadDate = "lastReadDate"
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
