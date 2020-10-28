//
//  ReadingHabitsBrain.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 27/10/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import Foundation
import RealmSwift

class ReadingEntriesBrain {
	private static let realm = RealmController.getReadingEntriesRealm()
	
	private static var readingEntries: [ReadingEntryModel] = []
	
	static func addReadingEntry(_ entry: ReadingEntryModel) {
		try! realm.write {
			realm.add(entry)
		}
	}
	
	static func deleteEntry(_ entry: ReadingEntryModel) {
		try! realm.write {
			realm.delete(entry)
		}
		loadReadingEntriesFromRealm()
	}
	
	static func getEntries() -> [ReadingEntryModel] {
		return readingEntries
	}
	
	static func addPagesToEntry(with date: String, pages: Int) {
		let entry = getReadingEntry(with: date)
		if (entry.pages + pages) >= 0 {
			try! realm.write {
				entry.pages += pages
			}
		} else {
			try! realm.write {
				entry.pages = 0
			}
		}
	}
	
	static func addBookToEntry(with date: String, book: BookModel) {
		let entry = getReadingEntry(with: date)
		try! realm.write {
			entry.books.append(book)
		}
	}
	
	private static func readingEntriesContainEntry(with date: String) -> Bool {
		var contains = false
		for entry in readingEntries {
			if entry.date == date {
				contains = true
			}
		}
		return contains
	}
	
	private static func getReadingEntry(with date: String) -> ReadingEntryModel {
		for entry in readingEntries {
			if entry.date == date {
				return entry
			}
		}
		
		let entry = ReadingEntryModel(date: date, pages: 0, books: List<BookModel>())
		addReadingEntry(entry)
		return entry
	}
	
	//MARK: - Realm
	
	static func saveReadingEntriesToRealm() {
		try! realm.write {
			realm.deleteAll()
			for entry in readingEntries {
				realm.add(entry)
			}
		}
	}
	
	static func loadReadingEntriesFromRealm() {
		readingEntries.removeAll()
		let loadedEntries = realm.objects(ReadingEntryModel.self)
		print(loadedEntries)
		for entry in loadedEntries {
			readingEntries.append(entry)
		}
	}
}
