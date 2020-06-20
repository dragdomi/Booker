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
		if (lhs.title == rhs.title) && (lhs.author == rhs.author) && (lhs.totalPages == rhs.totalPages) && (lhs.pagesRead == rhs.pagesRead) && (lhs.beginDate == rhs.beginDate) && (lhs.finishDate == rhs.finishDate) {
			return true
		} else {
			return false
		}
	}
	
	var title: String
	var author: String
	var totalPages: Int
	var pagesRead: Int
	var beginDate: String
	var finishDate: String
	
	enum CodingKeys: String, CodingKey {
        case title
        case author
        case totalPages
        case pagesRead
        case beginDate
		case finishDate
    }
}
