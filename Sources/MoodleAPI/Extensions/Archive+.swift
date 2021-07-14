//
//  Archive+.swift
//  
//
//  Created by Simon Schöpke on 14.07.21.
//

import ZIPFoundation
import Foundation

extension Archive {
    static func createCompressedData(from directory: URL) throws -> Data {
        guard let archive = try Archive(item: directory) else {
            throw ArchiveError.couldNotCreateArchive
        }
        
        guard let archiveData = archive.data else {
            throw ArchiveError.noArchiveDataAvailable
        }
        
        return archiveData
    }
    
    private convenience init?(item: URL) throws {
        self.init(accessMode: .create)
        let name = item.lastPathComponent
        let baseURL = item.deletingLastPathComponent()
        try addItem(itemPath: name, relativeTo: baseURL)
    }
    
    private func addItem(itemPath: String, relativeTo baseURL: URL) throws {
        try self.addEntry(with: itemPath, relativeTo: baseURL, compressionMethod: .deflate)
        let itemUrl = baseURL.appendingPathComponent(itemPath)
        if itemUrl.hasDirectoryPath {
            let items = try FileManager.default.contentsOfDirectory(atPath: itemUrl.path)
            let relativeItemPaths = items.lazy.map { "\(itemPath)/\($0)" }
            for relativeItemPath in relativeItemPaths {
                try self.addItem(itemPath: relativeItemPath, relativeTo: baseURL)
            }
        }
    }
    
    enum ArchiveError: Error {
        case couldNotCreateArchive
        case noArchiveDataAvailable
    }
}
