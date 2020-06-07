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
    let filesManager = FilesManager()
    
    enum Error: Swift.Error {
        case saveFailed
        case readFailed
    }
    
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
    
    func saveToFile() throws {
        let propertyListEncoder = PropertyListEncoder()
        let encodedBooks = try? propertyListEncoder.encode(books)
        
        if let safeEncodedBooks = encodedBooks {
            do {
                try filesManager.save(fileName: "Books", data: safeEncodedBooks)
            } catch {
                throw Error.saveFailed
            }
        }
    }
    
    mutating func loadFromFile() {
        let propertyListDecoder = PropertyListDecoder()
        
        if let booksData = try? filesManager.read(fileName: "Books") {
            if let decodedBooks = try? propertyListDecoder.decode([BookModel].self, from: booksData) {
                self.books = decodedBooks
            }
        }
    }

}
