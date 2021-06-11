//
//  URLSession+.swift
//  
//
//  Created by Simon Schöpke on 04.06.21.
//

import Foundation
import SwiftSoup

extension URLSession {
    private static let group = DispatchGroup()
    func documentTask(with url: URL) -> Document? {
        let request = URLRequest(url: url)
        return documentTask(with: request)
    }
}

extension URLSession {
    func documentTask(with request: URLRequest) -> Document? {
        guard let html = stringTask(with: request) else { return nil }
        return try? SwiftSoup.parse(html)
    }
}

extension URLSession {
    private func stringTask(with request: URLRequest) -> String? {
        guard let data = dataTask(with: request) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension URLSession {
    private func dataTask(with request: URLRequest) -> Data? {
        var data: Data?
        
        URLSession.group.enter()
        
        dataTask(with: request) { requestedData, _, _ in
            data = requestedData
            URLSession.group.leave()
        }.resume()
        
        URLSession.group.wait()
        
        return data
    }
}

extension URLSession {
    func downloadTask(with url: URL, saveFileTo destination: URL) throws {
        var error: Error?
        
        URLSession.group.enter()
        
        downloadTask(with: url) { tempFileURL, _, _ in
            defer { URLSession.group.leave() }
            guard let tempFileURL = tempFileURL else { return }
            FileManager.default.removeExistingFile(destination)
            error = FileManager.default.copyItem(at: tempFileURL, to: destination)
        }.resume()
        
        URLSession.group.wait()
        
        if let error = error {
            throw error
        }
    }
}
