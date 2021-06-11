//
//  URLSession+.swift
//  
//
//  Created by Simon Schöpke on 04.06.21.
//

import Foundation
import SwiftSoup

extension URLSession {
    func document(from url: URL) async throws -> Document {
        let request = URLRequest(url: url)
        return try await document(with: request)
    }
    
    func document(with request: URLRequest) async throws -> Document {
        let html = try await string(with: request)
        return try SwiftSoup.parse(html)
    }
    
    private func string(with request: URLRequest) async throws -> String {
        let (data, response) = try await URLSession.shared.data(for: request)
        try response.checkForStatusCode(200)
        return try String(data: data)
    }
    
    func downloadFile(from url: URL, saveTo destination: URL) async throws {
        let (tempURL, response) = try await self.download(from: url)
        try response.checkForStatusCode(200)
        FileManager.default.removeIfFileExists(destination)
        try FileManager.default.moveItem(at: tempURL, to: destination)
    }
}
