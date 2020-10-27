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
