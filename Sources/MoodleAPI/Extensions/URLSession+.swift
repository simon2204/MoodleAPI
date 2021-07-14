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
    func document(from url: URL) throws -> Document {
        let request = URLRequest(url: url)
        return try document(with: request)
    }
    
    func document(with request: URLRequest) throws -> Document {
        let html = try content(with: request)
        return try SwiftSoup.parse(html)
    }
}

// MARK: - Synchronously downloading content
extension URLSession {
    private func content(with request: URLRequest) throws -> String {
        let data: Data = try synchronousDataTask(with: request)
        return try String(data: data)
    }
    
    private func synchronousDataTask(with request: URLRequest) throws -> Data {
        let (data, response, error) = synchronousDataTask(with: request)
        try error.throwIfNotNil()
        try response.checkForStatusCode(200...299)
        return try data.unwrapped()
    }
    
    private func synchronousDataTask(with request: URLRequest) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        let dataTask = self.dataTask(with: request) {
            data = $0
            response = $1
            error = $2
            semaphore.signal()
        }
        dataTask.resume()

        semaphore.wait()

        return (data, response, error)
    }
}

// MARK: - Synchronously downloading a file
extension URLSession {
    func downloadFile(from url: URL, saveTo destination: URL) throws {
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)
        
        downloadFile(from: url, saveTo: destination) {
            error = $0
            semaphore.signal()
        }
        
        try error.throwIfNotNil()
    
        _ = semaphore.wait(timeout: .distantFuture)
    }
        
    private func downloadFile(from url: URL, saveTo destination: URL, completionHandler: @escaping (Error?) -> Void) {
        let task = downloadTask(with: url) { tempFile, response, rError in
            if let rError = rError {
                completionHandler(rError)
            }
            if let tempFile = tempFile, response.hasStatusCode(200...299) {
                FileManager.default.removeIfFileExists(destination)
                do {
                    try FileManager.default.moveItem(at: tempFile, to: destination)
                    completionHandler(nil)
                } catch {
                    completionHandler(error)
                }
            } else {
                completionHandler(URLResponse.URLResonseError.invalidServerResponse)
            }
        }
        task.resume()
    }
}
