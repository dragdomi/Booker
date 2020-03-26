//
//  BookModel.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 14/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import Foundation

struct BookModel: Codable {
    var title: String
    var author: String
    var totalPages: Int
    var pagesRead: Int
    var beginDate: Date
    var finishDate: Date?
}
