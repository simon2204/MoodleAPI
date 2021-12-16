//
//  MoodleSession.swift
//  
//
//  Created by Simon Schöpke on 30.05.21.
//

import Foundation
import SwiftSoup
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
    
    var info: MoodleSessionInfo!
    
    private var userIsLoggedIn: Bool = false
    
    public init() {
        
    }
	
	/// - Parameters:
	///   - name: Moodle Benutzername
	///   - password: Moodle Passwort
	public func login(name: String, password: String) async throws {
		self.info = try await Self.getMoodleSessionInfo(name: name, password: password)
		userIsLoggedIn = true
	}
    
    private static func getMoodleSessionInfo(name: String, password: String) async throws -> MoodleSessionInfo {
        let loginDocument = try await getLoginDocument(name: name, password: password)
        let moodleSessionInfo = try MoodleSessionInfo(document: loginDocument)
        return moodleSessionInfo
    }
    
    private static func getLoginDocument(name: String, password: String) async throws -> Document {
        let homeDocument = try await getHomeDocument()
        let moodleLogin = try MoodleLogin(document: homeDocument, name: name, password: password)
        let moodleLoginRequest = moodleLogin.request()
        return try await session.document(with: moodleLoginRequest)
    }
    
    private static func getHomeDocument() async throws -> Document {
        try await session.document(from: homeURL)
    }
    
    /// Beendigung der Session durch Ausloggen des verwendeten Benutzers.
    public func logOut() {
		if let info = info {
			MoodleSession.session.dataTask(with: info.logoutURL).resume()
		}
        userIsLoggedIn = false
    }
    
    deinit {
        if userIsLoggedIn {
            logOut()
        }
    }
}
