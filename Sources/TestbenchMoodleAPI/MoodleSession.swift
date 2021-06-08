//
//  MoodleSession.swift
//  
//
//  Created by Simon Schöpke on 30.05.21.
//

import Foundation
import SwiftSoup

class MoodleSession {
    private static let session = URLSession.shared
    
    static let homeURL: URL = "https://moodle.w-hs.de"
    
    let info: MoodleSessionInfo
    
    init?(name: String, password: String) {
        guard let info = Self.getMoodleSessionInfo(username: name, password: password) else {
            return nil
        }
        self.info = info
    }
    
    private static func getMoodleSessionInfo(username: String, password: String) -> MoodleSessionInfo? {
        guard let loginDocument = try? getLoginDocument(username: username, password: password) else {
            return nil
        }
        return try? MoodleSessionInfo(document: loginDocument)
    }
    
    private static func getLoginDocument(username: String, password: String) throws -> Document? {
        guard let homeDocument = getHomeDocument() else { return nil }
        let moodleLogin = try MoodleLogin(document: homeDocument, username: username, password: password)
        return session.documentTask(with: moodleLogin.request())
    }
    
    private static func getHomeDocument() -> Document? {
        return session.documentTask(with: homeURL)
    }
    
    func logOut() {
        MoodleSession.session.dataTask(with: info.logOutURL).resume()
    }
    
    deinit {
        logOut()
    }
}
