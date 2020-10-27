//
//  RealmController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 27/10/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import Foundation
import RealmSwift

class RealmController {
	private static let booksRealm = try! Realm(configuration: getBooksRealmConfig())
	private static let readingEntriesRealm = try! Realm(configuration: getReadingEntriesRealmConfig())
	
	enum Error: Swift.Error {
		case saveFailed
		case readFailed
	}
	
	//MARK: - Configurations
	
	private static func getBooksRealmConfig() -> Realm.Configuration {
		var config = Realm.Configuration()
		config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("BooksRealm.realm")
		return config
	}
	
	private static func getReadingEntriesRealmConfig() -> Realm.Configuration {
		var config = Realm.Configuration()
		config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("ReadingEntries.realm")
		return config
	}
	
	//MARK: - Realm getters
	
	static func getBooksRealm() -> Realm {
		return booksRealm
	}
	
	static func getReadingEntriesRealm() -> Realm {
		return readingEntriesRealm
	}
}
