//
//  NetworkingManager.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 04/11/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

//TODO: - Deconstruct this file to smaller ones

import UIKit

class Welcome: Codable {
	let kind: String
	let totalItems: Int
	let items: [Item]
	
	init(kind: String, totalItems: Int, items: [Item]) {
		self.kind = kind
		self.totalItems = totalItems
		self.items = items
	}
}

class Item: Codable {
	let volumeInfo: VolumeInfo
	
	init(volumeInfo: VolumeInfo) {
		self.volumeInfo = volumeInfo
	}
}

class VolumeInfo: Codable {
	let title: String
	let authors: [String]
	let publishedDate: String
	let pageCount: Int
	let imageLinks: ImageLinks
	let publisher: String?
	let subtitle: String?
	let industryIdentifiers: [IndustryIdentifier]
	
	enum CodingKeys: String, CodingKey {
		case title, authors, publishedDate, pageCount, imageLinks, publisher, industryIdentifiers
		case subtitle
	}
	
	init(title: String, authors: [String], publishedDate: String, pageCount: Int, imageLinks: ImageLinks, publisher: String?, subtitle: String?, industryIdentifiers: [IndustryIdentifier]) {
		self.title = title
		self.authors = authors
		self.publishedDate = publishedDate
		self.pageCount = pageCount
		self.imageLinks = imageLinks
		self.publisher = publisher
		self.subtitle = subtitle
		self.industryIdentifiers = industryIdentifiers
	}
}

class ImageLinks: Codable {
	let smallThumbnail, thumbnail: String
	
	init(smallThumbnail: String, thumbnail: String) {
		self.smallThumbnail = smallThumbnail
		self.thumbnail = thumbnail
	}
}

class IndustryIdentifier: Codable {
	let type: TypeEnum
	let identifier: String
	
	init(type: TypeEnum, identifier: String) {
		self.type = type
		self.identifier = identifier
	}
}

enum TypeEnum: String, Codable {
	case isbn10 = "ISBN_10"
	case isbn13 = "ISBN_13"
	case other = "OTHER"
}

class NetworkingManager {
	var items: [Item] = []
	enum NetworkError: Error {
		case url
		case server
	}
	
	func load(query: String) {
		DispatchQueue.global(qos: .utility).async {
			let result = self.makeAPICall(query: query)
			DispatchQueue.main.async {
				switch result {
				case let .success(data):
					self.decodeJSON(data: data)
				case let .failure(error):
					print(error)
				}
			}
		}
	}
	
	func makeAPICall(query: String) -> Result<Data, NetworkError> {
		let path = "https://www.googleapis.com/books/v1/volumes?q=\(query)&key=\(Constants.apiKey)"
		
		guard let url = URL(string: path) else {
			return .failure(.url)
		}
		
		var result: Result<Data, NetworkError>!
		
		let semaphore = DispatchSemaphore(value: 0)
		
		URLSession.shared.dataTask(with: url) { (data, _, _) in
			if let data = data {
				result = .success(data)
			} else {
				result = .failure(.server)
			}
			semaphore.signal()
		}.resume()
		
		_ = semaphore.wait(wallTimeout: .distantFuture)
		
		return result
	}
	
	func decodeJSON(data: Data)  {
		do {
			let json = try JSONDecoder().decode(Welcome.self, from: data)
			items = json.items
		} catch {
			print("Error during JSON serialization: \(error.localizedDescription)")
		}
	}
}
