//
//  Archive+.swift
//  
//
//  Created by Simon Schöpke on 14.07.21.
//

import ZIPFoundation
import Foundation

extension Archive {
    static func createData(from directory: URL) throws -> Data {
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
        try add(item: name, relativeTo: baseURL)
    }
    
    private func add(item: String, relativeTo baseURL: URL) throws {
        try self.addEntry(with: item, relativeTo: baseURL, compressionMethod: .deflate)
        let fileManager = FileManager.default
        let absolute = baseURL.appendingPathComponent(item)
        if absolute.hasDirectoryPath {
            let items = try fileManager.contentsOfDirectory(atPath: absolute.path)
            let relativeItemPaths = items.map { "\(item)/\($0)" }
            for relativeItemPath in relativeItemPaths {
                try self.add(item: relativeItemPath, relativeTo: baseURL)
            }
        }
    }
    
    enum ArchiveError: Error {
        case couldNotCreateArchive
        case noArchiveDataAvailable
    }
}
