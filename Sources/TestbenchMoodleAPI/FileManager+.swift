//
//  FileManager+.swift
//  
//
//  Created by Simon Schöpke on 07.06.21.
//

import Foundation

extension FileManager {
    func copyItem(at srcURL: URL, to dstURL: URL) -> Error? {
        do { try self.copyItem(atPath: srcURL.path, toPath: dstURL.path) }
        catch { return error }
        return nil
    }
    
    func removeExistingFile(_ url: URL) {
        let fileExists = FileManager.default.fileExists(atPath: url.path)
        if fileExists { try? FileManager.default.removeItem(at: url) }
    }
}
