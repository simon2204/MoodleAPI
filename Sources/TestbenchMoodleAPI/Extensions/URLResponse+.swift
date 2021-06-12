//
//  URLResponse+.swift
//  
//
//  Created by Simon Schöpke on 11.06.21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLResponse {
    func checkForStatusCode(_ statusCode: Int) throws {
        guard hasStatusCode(200) else {
            throw URLResonseError.invalidServerResponse
        }
    }
    
    func hasStatusCode(_ statusCode: Int) -> Bool {
        let httpResonse = self as? HTTPURLResponse
        return httpResonse?.statusCode == statusCode
    }
    
    enum URLResonseError: Error {
        case invalidServerResponse
    }
}

extension Optional where Wrapped == URLResponse {
    func hasStatusCode(_ statusCode: Int) -> Bool {
        guard let response = self else { return false }
        let httpResonse = response as? HTTPURLResponse
        return httpResonse?.statusCode == statusCode
    }
}
