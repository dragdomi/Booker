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
	private static let realm = try! Realm()
	
	enum Error: Swift.Error {
		case saveFailed
		case readFailed
	}
	
	static func getRealm() -> Realm {
		return realm
	}
}
