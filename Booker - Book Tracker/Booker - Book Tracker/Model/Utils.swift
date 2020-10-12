//
//  Utils.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 28/07/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import Foundation
import RealmSwift

class Utils {
	static func formatDateToString(_ date: Date?) -> String {
		let df = DateFormatter()
		df.dateFormat = Constants.dateFormat
		
		if let date = date {
			let dateString = df.string(from: date)
			return dateString
		} else {
			return ""
		}
	}
	
	static func formatStringToDate(_ string: String) -> Date?{
		let df = DateFormatter()
		df.dateFormat = Constants.dateFormat
		
		if string != "" {
			let date = df.date(from: string)
			return date
		} else {
			return nil
		}
	}
	
	static func getListFromArray(_ array: [String]) -> List<String> {
		let list = List<String>()
		if array.isEmpty { return list }
		else {
			for object in array {
				list.append(object)
			}
			return list
		}
	}
	
	static func getArrayFromList(_ list: List<String>) -> [String] {
		var array = [String]()
		if list.isEmpty { return array }
		else {
			for object in list {
				array.append(object)
			}
			return array
		}
	}
}
