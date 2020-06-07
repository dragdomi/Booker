//
//  FileManager.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 04/04/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

class FilesManager {
    enum Error: Swift.Error {
        case fileAlreadyExists
        case invalidDirectory
        case writtingFailed
        case fileDoesNotExist
        case readingFailed
    }
    
    let fileManager: FileManager
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    func save(fileName: String, data: Data) throws {
        guard let url = makeURL(forFileNamed: fileName) else {
            throw Error.invalidDirectory
        }
    
        do {
            try data.write(to: url, options: .noFileProtection)
        } catch {
            debugPrint(error)
            throw Error.writtingFailed
        }
    }

    func read(fileName: String) throws -> Data {
        guard let url = makeURL(forFileNamed: fileName) else {
            throw Error.invalidDirectory
        }
        
        guard fileManager.fileExists(atPath: url.absoluteString) else {
            throw Error.fileDoesNotExist
        }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            debugPrint(error)
            throw Error.readingFailed
        }
    }
    
    private func makeURL(forFileNamed fileName: String) -> URL? {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(fileName)
    }
}
