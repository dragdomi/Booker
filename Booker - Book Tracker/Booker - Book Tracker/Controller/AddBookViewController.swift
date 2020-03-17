//
//  AddBookViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 14/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController {
    @IBOutlet weak var bookTitleTextField: UITextField!
    @IBOutlet weak var bookAuthorTextField: UITextField!
    @IBOutlet weak var totalPagesTextField: UITextField!
    @IBOutlet weak var pagesReadTextField: UITextField!
    @IBOutlet weak var beginDatePicker: UIDatePicker!
    @IBOutlet weak var addBookButton: UIButton!
    
    let viewController = ViewController()
    var bookTitle: String?
    var bookAuthor: String?
    var bookTotalPages: Int?
    var bookPagesRead: Int?
    var beginDate: Date?
    
    override func viewDidLoad() {
        addBookButton.isEnabled = false
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        if let senderText = sender.text {
            switch sender.tag {
            case 0:
                bookTitle = senderText
            case 1:
                bookAuthor = senderText
            case 2:
                if let senderInt = Int(senderText) {
                    bookTotalPages = senderInt
                }
            case 3:
                if let senderInt = Int(senderText) {
                    bookPagesRead = senderInt
                }
            default:
                print("Out of cases")
            }
        }
        activateButton()
    }
    @IBAction func beginDateChanged(_ sender: UIDatePicker) {
        beginDate = sender.date
        activateButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func activateButton() {
        if (bookTitle != nil) && (bookAuthor != nil) && (bookTitle != nil) && (bookTotalPages != nil) && (bookPagesRead != nil) && (beginDate != nil) {
            addBookButton.isEnabled = true
        }
    }
    
    @IBAction func addBookButtonPressed(_ sender: UIButton) {
        viewController.bookBrain.addBook(title: bookTitle!, author: bookAuthor!, totalPages: bookTotalPages!, pagesRead: bookPagesRead!, beginDate: beginDate!, finishDate: nil)
        viewController.bookBrain.saveToFile()
        self.dismiss(animated: true, completion: nil)
    }
}
