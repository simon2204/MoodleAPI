//
//  MoodleApplication.swift
//  
//
//  Created by Simon Schöpke on 07.06.21.
//

import Foundation

struct MoodleApplication {
    private static let submissions = "submissions.zip"
    
    let session: MoodleSession
    
    func downloadSubmissions(forId assignmentId: Int, to destination: URL) throws {
        let itemName = destination.appendingPathComponent(MoodleApplication.submissions)
        let downloadURL = moodleDownloadURL(forId: assignmentId)
        return try URLSession.shared.downloadTask(with: downloadURL, saveFileTo: itemName)
    }
    
    private func moodleDownloadURL(forId assignmentId: Int) -> URL {
        let moodlePath = MoodleSession.homeURL.absoluteString
        let downloadPath = "\(moodlePath)/mod/assign/view.php?id=\(assignmentId)&action=downloadall"
        return URL(string: downloadPath)!
    }
}
