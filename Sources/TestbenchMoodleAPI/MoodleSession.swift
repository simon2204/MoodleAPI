//
//  MoodleSession.swift
//  
//
//  Created by Simon Schöpke on 30.05.21.
//

import Foundation
import SwiftSoup

/// Ein Objekt welches Zugriff auf die Moodle-Funktionen eines bestimmten Benutzers ermöglicht.
///
/// ## Überblick
/// Die `MoodleSession` wird benötigt, um benutzerspezifische Aktionen durchzuführen.
/// Zum Beispiel über den PPR-Benutzeraccount, um eingereichte Praktikumsaufgaben herunterzuladen
/// oder um die Auswertungsprotokolle dieser Praktikumsaufgaben hochzuladen.
/// Die `MoodleSession` ist allerdings nicht für das Hoch- und Runterladen verantwortlich,
/// sondern dient nur dazu "Erlaubnis" durch Login eines bestimmten Benutzers Zugriff darauf zu bekommen.
///
/// Nach Verwendung der `MoodleSession`, kann der Benutzer anschließend durch ``MoodleSession/logOut()`` ausgeloggt werden.
///
/// - Note: Die `MoodleSession` muss nicht explizit durch ``MoodleSession/logOut()`` beendet werden,
/// das geschieht automatisch, wenn keine Referenz mehr auf das Objekt existiert.
///
public final class MoodleSession {
    private static let session = URLSession.shared
    
    static let homeURL: URL = "https://moodle.w-hs.de"
    
    let info: MoodleSessionInfo
    
    private var userIsLoggedIn: Bool
    
    /// Erstellt eine neue `MoodleSession` mit einem gültigen Benutzernamen und Passwort.
    /// - Parameters:
    ///   - name: Moodle Benutzername
    ///   - password: Moodle Passwort
    public init?(name: String, password: String) {
        guard let info = Self.getMoodleSessionInfo(username: name, password: password) else {
            return nil
        }
        self.info = info
        self.userIsLoggedIn = true
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
    
    /// Beendigung der Session durch Ausloggen des verwendeten Benutzers.
    public func logOut() {
        MoodleSession.session.dataTask(with: info.logOutURL).resume()
        userIsLoggedIn = false
    }
    
    deinit {
        if userIsLoggedIn {
            logOut()
        }
    }
}
