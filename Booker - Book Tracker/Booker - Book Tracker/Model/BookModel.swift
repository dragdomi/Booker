//
//  BookModel.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 14/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import Foundation

struct BookModel {
    let Title: String
    let Author: String
    let totalPages: Int
    var pagesRead: Int
    let beginDate: Date
    let finishDate: Date?
}
