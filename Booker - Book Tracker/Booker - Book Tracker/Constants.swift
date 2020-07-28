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
	static let cellIdentifier = "BookCell"
	static let cellNibName = "BookCell"
	struct ViewControllers {
		static let books = "BooksViewController"
		static let addBook = "AddBookViewController"
		static let bookDetails = "BookDetailsViewController"
		static let login = "LoginViewController"
		static let register = "RegisterViewController"
		static let readingHabits = "ReadingHabitsViewController"
		static let userProfile = "UserProfileViewController"
	}
	
	struct FStore {
		static let usersCollectionName = "users"
		static let collectionName = "books"
		static let uid = "uid"
		static let id = "id"
		static let title = "title"
		static let author = "author"
		static let totalPages = "totalPages"
		static let pagesRead = "pagesRead"
		static let beginDate = "beginDate"
		static let finishDate = "finishDate"
		static let lastReadDate = "lastReadDate"
	}
}
