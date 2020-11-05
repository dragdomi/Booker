//
//  SearchOnlineViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 05/11/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

//TODO: - Fix fetching books from API

import UIKit

class SearchOnlineViewController: UIViewController {
	let networkingManager = NetworkingManager()
	var searchController = UISearchController()
	var books: [Item] = [] {
		didSet {
			tableView.reloadData()
		}
	}
	var selectedBook: Item?
	var searchText: String?
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	func setupUI() {
		self.title = "Search Books Online"
		navigationController?.navigationBar.prefersLargeTitles = false
		setupSearchController()
	}
	
	func setupSearchController() {
		let controller = UISearchController(searchResultsController: nil)
		controller.searchResultsUpdater = self
		controller.searchBar.sizeToFit()
		controller.obscuresBackgroundDuringPresentation = false
		controller.hidesNavigationBarDuringPresentation = false
		controller.searchBar.placeholder = "Search..."
		controller.searchBar.searchTextField.backgroundColor = .lightPrimary
		controller.view.tintColor = .accent
		
		searchController = controller
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
	}
	
	func filterContentForSearchText(_ searchText: String) {
		self.searchText = searchText
		loadBooks(searchBy: searchText)
	}
	
	func loadBooks(searchBy query: String) {
		print(query)
		networkingManager.load(query: query)
//		print(networkingManager.items)
		self.books = networkingManager.items
	}
	
}

extension SearchOnlineViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return books.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.searchOnlineCellIdentifier, for: indexPath) as! UITableViewCell
		cell.textLabel?.text = books[indexPath.row].volumeInfo.title
		return cell
	}
	
	
}

extension SearchOnlineViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		let searchBarText = searchBar.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
		if let searchText = searchBarText {
			filterContentForSearchText(searchText)
		}
	}
}
