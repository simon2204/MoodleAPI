//
//  URLResponse+.swift
//  
//
//  Created by Simon Schöpke on 11.06.21.
//

import Foundation

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
