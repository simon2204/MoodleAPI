//
//  MoodleSubmissionExtractor.swift
//  
//
//  Created by Simon Schöpke on 08.06.21.
//

import Foundation
import ZIPFoundation

/// Ansammlung von Einreichungen einer Praktikumsaufgabe in Moodle.
///
/// ## Überblick
/// Über Moodle lassen sich Praktikumsaufgaben einreichen und wieder herunterladen, um sie auszuwerten.
/// Diese Collection von ``MoodleSubmission`` enthält alle eingereichten Praktikumsaufgaben.
/// `MoodleSubmissionExtractor` lässt einen über die einzelnen ``MoodleSubmission``s
/// in einer Schleife iterieren oder man verwendet Subscripting um eine bestimmte ``MoodleSubmission``
/// zu erhalten.
///
/// Eine `MoodleSubmissionExtractor` erstellt man nicht selbst, sondern wird durch
/// ``MoodleApplication/downloadSubmissions(forId:to:)`` geliefert. Zum Beispiel:
/// ```swift
/// let username = "benutzerName"
/// let password = "benutzerPasswort"
///
/// enum Assignments: Int {
///     case ulam = 129974
///     case determinante = 129975
///     case gameOfLife = 129976
/// }
///
/// let assignmentId = Assignments.ulam.rawValue
/// let destination = URL(fileURLWithPath: "/Users/Simon/Downloads")
///
/// let moodleSession = try MoodleSession(name: username, password: password)
/// let moodleApplication = MoodleApplication(session: moodleSession)
/// let submissions = try moodleApplication.downloadSubmissions(forId: assignmentId, to: destination)
/// ```
///
/// ### Zugriff auf Einreichungen
///
/// Um über die einzelnen `MoodleSubmission`s zu iterieren,
/// ist es am einfachsten eine `for-in` Schleife zu verwenden.
/// Zum Beispiel:
/// ```swift
/// for submission in submissions {
///     reviewSubmission(submission)
/// }
/// ```
///
/// Um eine einzelne Einreichung zu bekommen ist es möglich Subscripting zu verwenden.
/// Zum Beispiel:
/// ```swift
/// let lastSubmissionIndex = submissions.count - 1
/// let lastSubmission = submissions[lastSubmissionIndex]
/// ```
///
struct MoodleSubmissionExtractor {
    private static let namePattern = ".+?(?=_\\d)"
    
    static func getSubmissions(from zippedItem: URL) throws -> [MoodleSubmission] {
        let unzipped = try FileManager.default.unzip(item: zippedItem)
        let submissionURLs = try getSubmissionURLs(submissionFolder: unzipped)
        return submissions(from: submissionURLs)
    }
    
    private static func submissions(from urls: [URL]) -> [MoodleSubmission] {
        urls.compactMap { url in
            guard let studentName = Self.studentName(from: url) else { return nil }
            return MoodleSubmission(name: studentName, submission: url)
        }
    }
    
    private static func getSubmissionURLs(submissionFolder: URL) throws -> [URL] {
        try FileManager.default.absoulteURLsforContentsOfDirectory(at: submissionFolder)
    }
    
    private static func studentName(from item: URL) -> String? {
        let itemName = item.lastPathComponent
        if let match = itemName.firstMatch(for: namePattern) {
            return String(match)
        }
        return nil
    }
}
