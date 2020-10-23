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
	
	//MARK: - Months
	
	static let months = ["January",
						 "February",
						 "March",
						 "April",
						 "May",
						 "June",
						 "July",
						 "August",
						 "September",
						 "October",
						 "November",
						 "December"]
	
	static let monthsNumbers = ["January": 1,
								"February": 2,
								"March": 3,
								"April": 4,
								"May": 5,
								"June": 6,
								"July": 7,
								"August": 8,
								"September": 9,
								"October": 10,
								"November": 11,
								"December": 12]
	
	//MARK: - Date/String
	
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
	
	//MARK: - List/Array
	
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
