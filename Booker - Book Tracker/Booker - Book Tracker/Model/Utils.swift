//
//  Utils.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 28/07/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import Foundation

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
}
