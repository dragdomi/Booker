//
//  AddBookViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 14/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

protocol AddBookViewControllerDelegate {
    func handleBookData(title: String, author: String, totalPages: Int, pagesRead: Int, beginDate: Date, finishDate: Date?)
}

class AddBookViewController: UIViewController {
    @IBOutlet weak var bookTitleTextField: UITextField!
    @IBOutlet weak var bookAuthorTextField: UITextField!
    @IBOutlet weak var totalPagesTextField: UITextField!
    @IBOutlet weak var pagesReadTextField: UITextField!
    @IBOutlet weak var bookFinishedSwitch: UISwitch!
    @IBOutlet weak var dateSwitcher: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addBookButton: UIButton!
    var delegate: AddBookViewControllerDelegate?
    var bookTitle: String?
    var bookAuthor: String?
    var bookTotalPages: Int?
    var bookPagesRead: Int?
    var beginDate: Date?
    var finishDate: Date?
    
    override func viewDidLoad() {
        if let safeBookTitle = bookTitle {
            bookTitleTextField.text = safeBookTitle
        }
        
        if let safeBookAuthor = bookAuthor {
            bookAuthorTextField.text = safeBookAuthor
        }
        
        if let safeBookTotalPages = bookTotalPages {
            totalPagesTextField.text = String(safeBookTotalPages)
        }
        
        if let safeBookPagesRead = bookPagesRead {
            pagesReadTextField.text = String(safeBookPagesRead)
        }
        
        if let safeBeginDate = beginDate {
            datePicker.date = safeBeginDate
        }
        
        addBookButton.isEnabled = false
        activateButton()
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        if let senderText = sender.text {
            switch sender.tag {
            case 0:
                bookTitle = senderText
            case 1:
                bookAuthor = senderText
            case 2:
                if let senderInt = Int(senderText) { bookTotalPages = senderInt }
            case 3:
                if let senderInt = Int(senderText) { bookPagesRead = senderInt }
            default:
                print("Out of cases")
            }
        }
        activateButton()
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if dateSwitcher.selectedSegmentIndex == 0 {
            if let safeBeginDate = beginDate {
                datePicker.date = safeBeginDate
            } else {
                datePicker.date = Date()
            }
        } else if dateSwitcher.selectedSegmentIndex == 1 {
            if let safeFinishDate = finishDate {
                datePicker.date = safeFinishDate
            } else {
                datePicker.date = Date()
            }
        }
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        if dateSwitcher.selectedSegmentIndex == 0 {
            beginDate = sender.date
        } else if dateSwitcher.selectedSegmentIndex == 1 {
            finishDate = sender.date
        } else {
            finishDate = nil
        }
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
    
    @IBAction func bookFinishedSwitch(_ sender: UISwitch) {
        if sender.isOn {
            dateSwitcher.insertSegment(withTitle: "Finish date", at: 2, animated: true)
        } else {
            dateSwitcher.removeSegment(at: 1, animated: true)
        }
    }
    
    @IBAction func addBookButtonPressed(_ sender: UIButton) {
        if let safeFinishDate = finishDate {
            if bookFinishedSwitch.isOn {
                delegate?.handleBookData(title: bookTitle!, author: bookAuthor!, totalPages: bookTotalPages!, pagesRead: bookPagesRead!, beginDate: beginDate!, finishDate: safeFinishDate)
            } else {
                delegate?.handleBookData(title: bookTitle!, author: bookAuthor!, totalPages: bookTotalPages!, pagesRead: bookPagesRead!, beginDate: beginDate!, finishDate: nil)
            }
        } else {
            delegate?.handleBookData(title: bookTitle!, author: bookAuthor!, totalPages: bookTotalPages!, pagesRead: bookPagesRead!, beginDate: beginDate!, finishDate: nil)
        }
        navigationController?.popViewController(animated: true)
    }
}
