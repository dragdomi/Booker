//
//  ViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 14/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, AddBookViewControllerDelegate {
    var bookBrain = BookBrain()
    
    override func viewDidLoad() {
        title = "Your books:"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBookButton))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookBrain.books.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Book", for: indexPath)
        cell.textLabel?.text = bookBrain.books[indexPath.row].title
        return cell
    }
    
    @objc func addBookButton() {
        if let addBookViewController = storyboard?.instantiateViewController(identifier: "AddBook") as? AddBookViewController {
            addBookViewController.delegate = self
            navigationController?.pushViewController(addBookViewController, animated: true)
        }
    }
    
    func addBook(title: String, author: String, totalPages: Int, pagesRead: Int, beginDate: Date, finishDate: Date?) {
        bookBrain.addBook(title: title, author: author, totalPages: totalPages, pagesRead: pagesRead, beginDate: beginDate, finishDate: finishDate)
    
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}
