//
//  BookBrain.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 14/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import Foundation

struct BookBrain {
	var books: [BookModel] = []
	
	enum Error: Swift.Error {
		case saveFailed
		case readFailed
	}
	
	mutating func addBook(_ book: BookModel) {
		books.insert(book, at: 0)
	}
	
	mutating func editBookData(oldBookData: BookModel, newBookData: BookModel) {
		var index = 0
		for book in books {
			if book == oldBookData {
				books[index] = newBookData
				break
			}
			index += 1
		}
	}
	
	
}
