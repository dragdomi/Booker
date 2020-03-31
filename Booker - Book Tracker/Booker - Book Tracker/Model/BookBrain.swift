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
    
    mutating func addBook(title: String, author: String, totalPages: Int, pagesRead: Int, beginDate: Date, finishDate: Date?) {
        books.insert(BookModel(title: title, author: author, totalPages: totalPages, pagesRead: pagesRead, beginDate: beginDate, finishDate: finishDate), at: 0)
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
    
    func saveToFile() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("Booker_test").appendingPathExtension("plist")
        let propertyListEncoder = PropertyListEncoder()
        
        let encodedBooks = try? propertyListEncoder.encode(books)
        try? encodedBooks?.write(to: archiveURL, options: .noFileProtection)
    }
    
    func loadFromFile() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("Booker_test").appendingPathExtension("plist")
        let propertyListDecoder = PropertyListDecoder()
        
        if let retrievedBooksData = try? Data(contentsOf: archiveURL), let decodedBooks = try? propertyListDecoder.decode(Array<BookModel>.self, from: retrievedBooksData) {
        }
    }
    
}
