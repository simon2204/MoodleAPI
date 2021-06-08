//
//  File.swift
//  
//
//  Created by Simon Schöpke on 08.06.21.
//

import Foundation

extension String {
    func matching(pattern: String) -> Substring? {
        let range: NSRange = matching(pattern: pattern)
        if let swiftRange = Range(range, in: self) {
            return self[swiftRange]
        }
        return nil
    }
    
    private func matching(pattern: String) -> NSRange {
        let range = NSRange(location: 0, length: self.utf16.count)
        let regex = try! NSRegularExpression(pattern: pattern)
        return regex.rangeOfFirstMatch(in: self, options: [], range: range)
    }
}
