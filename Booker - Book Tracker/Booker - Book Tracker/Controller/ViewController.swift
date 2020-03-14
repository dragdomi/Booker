//
//  ViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 14/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var bookBrain = BookBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBook))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookBrain.books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Book", for: indexPath)
        cell.textLabel?.text = bookBrain.books[indexPath.row].title
        return cell
    }
    
    @objc func addBook() {
        //TODO: Go to a view, which will gather book info
        self.performSegue(withIdentifier: "AddBook", sender: self)
    }
    
    
    
    

}

