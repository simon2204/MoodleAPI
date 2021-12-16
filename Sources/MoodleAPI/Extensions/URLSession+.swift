//
//  URLSession+.swift
//  
//
//  Created by Simon Schöpke on 04.06.21.
//

import Foundation
import SwiftSoup
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {
    func document(from url: URL) async throws -> Document {
        let request = URLRequest(url: url)
        return try await document(with: request)
    }
    
    func document(with request: URLRequest) async throws -> Document {
        let html = try await content(with: request)
        return try SwiftSoup.parse(html)
    }
}


extension URLSession {
    private func content(with request: URLRequest) async throws -> String {
        let (data, response) = try await URLSession.shared.data(for: request)
        try response.checkForStatusCode(200...299)
        return try String(data: data)
    }
}


extension URLSession {
    func download(from url: URL, saveTo destination: URL) async throws {
        let (tempFile, response) = try await download(from: url)
        try response.checkForStatusCode(200...299)
        FileManager.default.removeIfFileExists(destination)
        try FileManager.default.moveItem(at: tempFile, to: destination)
    }
}

#if os(Linux)
extension URLSession {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await data(for: URLRequest(url: url))
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: (data!, response!))
                }
            }.resume()
        }
    }
    
    func download(from url: URL) async throws -> (URL, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            downloadTask(with: url) { file, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    do {
                        let tempDirectory = try FileManager.default.randomTempDirectory()
                        let fileName = file!.lastPathComponent
                        let newLocation = tempDirectory.appendingPathComponent(fileName)
                        try FileManager.default.moveItem(at: file!, to: newLocation)
                        continuation.resume(returning: (newLocation, response!))
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }.resume()
        }
    }
}
#endif
