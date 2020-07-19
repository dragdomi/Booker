//
//  BookModel.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 14/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import Foundation

struct BookModel: Codable, Comparable {
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
	
	var id: Int
	var title: String
	var author: String
	var totalPages: Int
	var pagesRead: Int
	var beginDate: String
	var finishDate: String
	var lastReadDate: String
	
	var readPercentage: Double {
		get {
			let percentage = (Double(pagesRead) / Double(totalPages)) * 100
			return percentage
		}
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
}
