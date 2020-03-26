//
//  BookDetailsViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 18/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

class BookDetailsViewController: UIViewController {
    var book: BookModel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var pagesReadLabel: UILabel!
    @IBOutlet weak var totalPagesLabel: UILabel!
    @IBOutlet weak var beginDateLabel: UILabel!
    @IBOutlet weak var finishDateLabel: UILabel!
    
    override func viewDidLoad() {
        titleLabel.text = book.title
        authorLabel.text = book.author
        pagesReadLabel.text = "Pages read: " + String(book.pagesRead)
        totalPagesLabel.text = "Total pages: " + String(book.totalPages)
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        let beginDate = df.string(from: book.beginDate)
        beginDateLabel.text = "Begin date: " + beginDate
        if let safeFinishDate = book.finishDate {
            let stringFinishDate = df.string(from: safeFinishDate)
            finishDateLabel.text = "Finish date: " + stringFinishDate
        } else {
            finishDateLabel.text = ""
        }
        
        
    }
}
