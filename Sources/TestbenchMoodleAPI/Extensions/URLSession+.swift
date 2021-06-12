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
    func document(from url: URL, completionHandler: @escaping (Document?, Error?) -> Void) {
        let request = URLRequest(url: url)
        document(with: request) { document, rError in
            if let rError = rError {
                completionHandler(nil, rError)
            }
            if let document = document {
                completionHandler(document, nil)
            }
        }
    }
    
    func document(with request: URLRequest, completionHandler: @escaping (Document?, Error?) -> Void) {
        string(with: request) { html, rError in
            if let rError = rError {
                completionHandler(nil, rError)
            }
            if let html = html {
                do {
                    let document = try SwiftSoup.parse(html)
                    completionHandler(document, nil)
                } catch {
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    private func string(with request: URLRequest, completionHandler: @escaping (String?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, rError in
            if let rError = rError {
                completionHandler(nil, rError)
            }
            if let data = data, response.hasStatusCode(200) {
                do {
                    let string = try String(data: data)
                    completionHandler(string, nil)
                } catch {
                    completionHandler(nil, error)
                }
            } else {
                completionHandler(nil, URLResponse.URLResonseError.invalidServerResponse)
            }
        }
        task.resume()
    }
    
    func synchronousDownloadTask(with url: URL, saveTo destination: URL) throws {
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)
        
        downloadFile(from: url, saveTo: destination) {
            error = $0
            semaphore.signal()
        }
        
        if let error = error {
            throw error
        }
    
        _ = semaphore.wait(timeout: .distantFuture)
    }
        
    func downloadFile(from url: URL, saveTo destination: URL, completionHandler: @escaping (Error?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { tempFile, response, rError in
            if let rError = rError {
                completionHandler(rError)
            }
            if let tempFile = tempFile, response.hasStatusCode(200) {
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
