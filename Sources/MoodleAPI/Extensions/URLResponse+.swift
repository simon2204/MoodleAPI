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
    func checkForStatusCode<Code: Sequence>(_ statusCode: Code) throws where Code.Element == Int {
        guard hasStatusCode(statusCode) else {
            throw URLResonseError.invalidServerResponse
        }
    }
    
    func hasStatusCode<Code: Sequence>(_ statusCode: Code) -> Bool where Code.Element == Int {
        guard let httpResonse = self as? HTTPURLResponse else { return false }
        return statusCode.contains(httpResonse.statusCode)
    }
    
    enum URLResonseError: Error {
        case invalidServerResponse
    }
}

extension Optional where Wrapped == URLResponse {
    func checkForStatusCode<Code: Sequence>(_ statusCode: Code) throws where Code.Element == Int {
        guard hasStatusCode(statusCode) else {
            throw URLResonseError.invalidServerResponse
        }
    }
    
    func hasStatusCode<Code: Sequence>(_ statusCode: Code) -> Bool where Code.Element == Int {
        guard let response = self,
            let httpResonse = response as? HTTPURLResponse else { return false }
        return statusCode.contains(httpResonse.statusCode)
    }
    
    enum URLResonseError: Error {
        case invalidServerResponse
    }
}
