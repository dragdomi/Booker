//
//  Date.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 22/10/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import Foundation

extension Date {
	func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
		return calendar.dateComponents(Set(components), from: self)
	}

	func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
		return calendar.component(component, from: self)
	}
}
