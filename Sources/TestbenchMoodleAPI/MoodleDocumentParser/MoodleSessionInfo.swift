//
//  MoodleSessionInfo.swift
//  
//
//  Created by Simon Schöpke on 30.05.21.
//

import Foundation
import SwiftSoup

struct MoodleSessionInfo {
    let logOutURL: URL
    let sessionId: String
    
    init(document: Document) throws {
        guard let logoutElement = try document.select("a[href*=logout.php]").first() else {
            throw MoodleSessionInfoError.noSuchElement(withCSSSelector: "a[href*=logout.php]")
        }
        
        let logOutPath = try logoutElement.attr("href")
        let components = URLComponents(string: logOutPath)!
        let logOutURL = components.url!
        
        let queryItems = components.queryItems
        
        let sesskey = queryItems?.first(where: \.name, equals: "sesskey")
        
        guard let sessionId = sesskey?.value else {
            throw MoodleSessionInfoError.noQueryItem(withName: "sesskey")
        }
        
        self.logOutURL = logOutURL
        self.sessionId = sessionId
    }
    
    enum MoodleSessionInfoError: Error {
        case noSuchElement(withCSSSelector: String)
        case noQueryItem(withName: String)
    }
}
