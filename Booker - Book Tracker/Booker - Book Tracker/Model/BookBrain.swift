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
    
    mutating func addBook() {
        //Prototype
        books.append(BookModel(title: "", author: "", totalPages: 0, pagesRead: 0, beginDate: Date(), finishDate: nil))
        print(books)
    }
}
