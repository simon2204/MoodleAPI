//
//  String+.swift
//  
//
//  Created by Simon Schöpke on 08.06.21.
//

import Foundation

extension String {
    func firstMatch(for pattern: String, groupIndex: Int) throws -> Substring {
        let range = NSRange(location: 0, length: self.utf16.count)
        
        let captureRegex = try! NSRegularExpression(
            pattern: pattern,
            options: []
        )
        
        let match = captureRegex.firstMatch(
            in: self,
            options: [],
            range: range
        )
        
        guard let m = match else {
            throw MatchError.noMatchFound(forPattern: pattern)
        }
        
        let matchRange = m.range(at: 1)
        
        // Extract the substring matching the capture group
        guard let substringRange = Range(matchRange, in: self) else {
            throw MatchError.rangeNotIncluded
        }
        
        return self[substringRange]
    }
    
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
    
    enum MatchError: Error {
        case noMatchFound(forPattern: String)
        case rangeNotIncluded
    }
}

extension String {
    init(data: Data) throws {
        guard let string = String(data: data, encoding: .utf8) else {
            throw StringError.invalidEncoding
        }
        self = string
    }
}

extension String {
    enum StringError: Error {
        case invalidEncoding
    }
}
