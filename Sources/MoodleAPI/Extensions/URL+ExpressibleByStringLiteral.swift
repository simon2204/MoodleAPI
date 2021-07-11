//
//  URL+ExpressibleByStringLiteral.swift
//  
//
//  Created by Simon Schöpke on 30.05.21.
//

import Foundation

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(string: value)!
    }
}
