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
        guard let httpResponse = self as? HTTPURLResponse,
                httpResponse.statusCode == statusCode else {
            throw URLResonseError.invalidServerResponse
        }
    }
    
    enum URLResonseError: Error {
        case invalidServerResponse
    }
}
