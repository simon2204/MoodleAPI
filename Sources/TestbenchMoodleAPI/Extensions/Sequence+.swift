//
//  Sequence+.swift
//  
//
//  Created by Simon Schöpke on 11.06.21.
//

import Foundation

extension Sequence {
    func first<Value: Equatable>(where keypath: KeyPath<Element, Value>, equals value: Value) -> Element? {
        self.first(where: { $0[keyPath: keypath] == value })
    }
}
