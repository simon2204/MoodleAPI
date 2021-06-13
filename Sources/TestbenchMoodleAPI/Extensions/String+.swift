//
//  String+.swift
//  
//
//  Created by Simon Schöpke on 08.06.21.
//

import Foundation

extension String {
    func firstMatch(for pattern: String) -> Substring? {
        let nsRange: NSRange = rangeOfFirstMatch(pattern: pattern)
        if let range = Range(nsRange, in: self) {
            return self[range]
        }
        return nil
    }
    
    private func rangeOfFirstMatch(pattern: String) -> NSRange {
        let nsRange = NSRange(location: 0, length: self.utf16.count)
        let regex = try! NSRegularExpression(pattern: pattern)
        return regex.rangeOfFirstMatch(in: self, options: [], range: nsRange)
    }
}

extension String {
    init(data: Data) throws {
        guard let string = String(data: data, encoding: .utf8) else {
            throw String.StringError.invalidEncoding
        }
        self = string
    }
}

extension String {
    enum StringError: Error {
        case invalidEncoding
    }
}
