//
//  File+.swift
//  
//
//  Created by Simon Schöpke on 14.07.21.
//

import Foundation
import ZIPFoundation
import FormData

extension File {
    static func zipped(from directory: URL) throws -> File {
        let zipName = directory.lastPathComponent + ".zip"
        let archiveData = try Archive.createData(from: directory)
        return File(name: zipName, content: archiveData, contentType: .zip)
    }
}
