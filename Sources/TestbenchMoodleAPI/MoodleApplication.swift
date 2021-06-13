//
//  MoodleApplication.swift
//  
//
//  Created by Simon Schöpke on 07.06.21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Herunterladen von Einreichungen in Moodle.
/// 
///
public struct MoodleApplication {
    private static let zipFileName = "submissions.zip"
    
    let session: MoodleSession
    
    public func downloadSubmissions(forId assignmentId: Int, to destination: URL) throws -> [MoodleSubmission] {
        let itemName = destination.appendingPathComponent(MoodleApplication.zipFileName)
        let downloadURL = moodleDownloadURL(forId: assignmentId)
        try URLSession.shared.downloadFile(from: downloadURL, saveTo: itemName)
        return try MoodleSubmissionExtractor.getSubmissions(from: itemName)
    }
    
    private func moodleDownloadURL(forId assignmentId: Int) -> URL {
        let moodlePath = MoodleSession.homeURL.absoluteString
        let downloadPath = "\(moodlePath)/mod/assign/view.php?id=\(assignmentId)&action=downloadall"
        return URL(string: downloadPath)!
    }
}
