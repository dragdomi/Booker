//
//  Constants.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 16/06/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

struct Constants {
	static let appName = "Booker 📚"
	static let dateFormat = "dd-MM-yyyy"
	struct ViewControllers {
		static let books = "BooksViewController"
		static let addBook = "AddBookViewController"
		static let bookDetails = "BookDetailsViewController"
		static let login = "LoginViewController"
		static let register = "RegisterViewController"
	}
	
	struct FStore {
		static let collectionName = "books"
		static let title = "title"
		static let author = "author"
		static let totalPages = "totalPages"
		static let pagesRead = "pagesRead"
		static let beginDate = "beginDate"
		static let finishDate = "finishDate"
	}
}
