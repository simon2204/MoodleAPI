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

extension FileManager {
    func randomTempDirectory() throws -> URL {
        let uuid = UUID().uuidString
        let randomTempDirectory = temporaryDirectory.appendingPathComponent(uuid)
        try createDirectory(at: temporaryDirectory, withIntermediateDirectories: false)
        return randomTempDirectory
    }
}

extension FileManager {
    func unzip(item: URL) throws -> URL {
        let unzippedURL = item.deletingPathExtension()
        FileManager.default.removeIfFileExists(unzippedURL)
        try FileManager.default.unzipItem(at: item, to: unzippedURL)
        try FileManager.default.removeItem(at: item)
        return unzippedURL
    }
}
