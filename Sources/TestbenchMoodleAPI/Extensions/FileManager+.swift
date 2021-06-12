//
//  FileManager+.swift
//  
//
//  Created by Simon Schöpke on 07.06.21.
//

import Foundation

extension FileManager {
    func removeIfFileExists(_ url: URL) {
        let fileExists = FileManager.default.fileExists(atPath: url.path)
        if fileExists { try? FileManager.default.removeItem(at: url) }
    }
    
    func absoulteURLsforContentsOfDirectory(at url: URL) throws -> [URL] {
        let items = try contentsOfDirectory(atPath: url.path)
        return items.map { url.appendingPathComponent($0) }
    }
}

