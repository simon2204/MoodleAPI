//
//  MoodleSubmissionCollection.swift
//  
//
//  Created by Simon Schöpke on 08.06.21.
//

import Foundation
import ZIPFoundation

struct MoodleSubmissionCollection {
    private static let namePattern = ".+?(?=_\\d)"
    
    private let submissions: [MoodleSubmission]
    
    init(zipArchive: URL) {
        submissions = Self.submissions(from: zipArchive)
    }
    
    private static func submissions(from zippedItem: URL) -> [MoodleSubmission] {
        guard let unzipped = try? Self.unzip(item: zippedItem) else { return [] }
        let submissionURLs = getSubmissionURLs(submissionFolder: unzipped)
        return submissions(from: submissionURLs)
    }
    
    private static func submissions(from urls: [URL]) -> [MoodleSubmission] {
        urls.compactMap { url in
            guard let studentName = Self.studentName(from: url) else { return nil }
            return MoodleSubmission(studentName: studentName, submission: url)
        }
    }
    
    private static func getSubmissionURLs(submissionFolder: URL) -> [URL] {
        FileManager.default.contentsOfDirectory(at: submissionFolder)
    }
    
    private static func unzip(item: URL) throws -> URL {
        let unzippedURL = item.deletingPathExtension()
        FileManager.default.removeExistingFile(unzippedURL)
        try FileManager.default.unzipItem(at: item, to: unzippedURL)
        try FileManager.default.removeItem(at: item)
        return unzippedURL
    }
    
    private static func studentName(from item: URL) -> String? {
        let itemName = item.lastPathComponent
        if let match = itemName.matching(pattern: namePattern) {
            return String(match)
        }
        return nil
    }
    
    struct MoodleSubmission {
        let studentName: String
        let submission: URL
    }
}

extension MoodleSubmissionCollection: Sequence {
    func makeIterator() -> Array<MoodleSubmission>.Iterator {
        self.submissions.makeIterator()
    }
}
