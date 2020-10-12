//
//  ImageDataManager.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 23/09/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

class ImageManager {
	static let defaultBookCover = UIImage(named: "book.closed")
	static func store (image: UIImage, forKey key: String) {
		if let jpegRepresentation = image.jpegData(compressionQuality: 1.0) {
			if let filePath = self.filePath(forKey: key) {
				do  {
					try jpegRepresentation.write(to: filePath,
												options: .atomic)
				} catch let err {
					print("Saving file resulted in error: ", err)
				}
			}
		}
	}
	
	static func retrieveImage(forKey key: String) -> UIImage? {
		if let filePath = self.filePath(forKey: key),
		   let fileData = FileManager.default.contents(atPath: filePath.path),
		   let image = UIImage(data: fileData) {
			return image
		}
		
		return nil
	}
	
	static func filePath(forKey key: String) -> URL? {
		let fileManager = FileManager.default
		guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else {
			return nil
		}
		
		return documentURL.appendingPathComponent(key + ".jpeg")
	}
	
	static func deleteImage(forKey key: String) {
		if let filePath = self.filePath(forKey: key) {
			do {
				try FileManager.default.removeItem(at: filePath)
			}
			catch {
				print("could not remove \(key) file")
			}
		}
	}
}
