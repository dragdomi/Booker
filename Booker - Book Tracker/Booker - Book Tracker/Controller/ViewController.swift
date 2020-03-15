//
//  ViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 14/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//
// TODO: Figure out how to update table view after dismissing AddBookViewController
import UIKit

class ViewController: UITableViewController {
    var bookBrain = BookBrain()
    
    override func viewDidLoad() {
        title = "Your books:"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBook))
    }
    
    @objc func addBook() {
        self.performSegue(withIdentifier: "AddBook", sender: self)
        bookBrain.addBook(title: "Essa", author: "Wariacie", totalPages: 3, pagesRead: 1, beginDate: Date(), finishDate: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookBrain.books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Book", for: indexPath)
        cell.textLabel?.text = bookBrain.books[indexPath.row].title
        return cell
    }
}

