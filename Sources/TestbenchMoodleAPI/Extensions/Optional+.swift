//
//  Optional+.swift
//  
//
//  Created by Simon Schöpke on 12.06.21.
//

import Foundation

extension Optional {
    func unwrapped() throws -> Wrapped {
        if let wrapped = self {
            return wrapped
        } else {
            throw OptionalError.hasNoValue
        }
    }
    
    enum OptionalError: Error {
        case hasNoValue
    }
}

extension Optional where Wrapped == Error {
    func throwIfNotNil() throws {
        if let error = self {
            throw error
        }
    }
}
