//
//  MoodleLogin.swift
//  
//
//  Created by Simon Schöpke on 30.05.21.
//

import SwiftSoup
import Foundation

struct MoodleLogin {
    private let action: URL
    private let method: HTTPMethod
    private let queryString: String
    
    init(document: Document, username: String, password: String) throws {
        guard let loginform = try document.getElementById("login") else {
            throw LoginFormError.noElement(withId: "login")
        }
        
        let action = try loginform.attr("action")
        let logintokenElement = try loginform.getElementsByAttributeValue("name", "logintoken")
        let logintoken = try logintokenElement.attr("value")
        let method = try loginform.attr("method")
         
        let parameters = [
            "username": username,
            "password": password,
            "rememberusername": "0",
            "logintoken": logintoken
        ]
        
        let queryString = parameters.lazy
            .map { "\($0)=\($1)" }
            .joined(separator: "&")
        
        self.action = URL(string: action)!
        self.method = HTTPMethod(rawValue: method.uppercased()) ?? .post
        self.queryString = queryString
    }
    
    func request() -> URLRequest {
        var request = URLRequest(url: action)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.rawValue
        request.httpBody = queryString.data(using: .utf8)
        return request
    }
    
    private enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum LoginFormError: Error {
        case noElement(withId: String)
    }
}
