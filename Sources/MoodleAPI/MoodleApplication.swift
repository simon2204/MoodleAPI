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

import FormData

/// Herunterladen von Einreichungen in Moodle.
/// 
///
public struct MoodleApplication {
    
    private static let zipFileName = "submissions.zip"
    
    private let session: MoodleSession
    
    public init(session: MoodleSession) {
        self.session = session
    }
    
    public func downloadSubmissions(forId assignmentId: Int, to destination: URL) throws -> [MoodleSubmission] {
        let itemName = destination.appendingPathComponent(Self.zipFileName)
        let downloadURL = moodleDownloadURL(forId: assignmentId)
        try URLSession.shared.downloadFile(from: downloadURL, saveTo: itemName)
        return try MoodleSubmissionExtractor.getSubmissions(from: itemName)
    }
    
    public func uploadFeedbackZIP(forId assignmentId: Int, from source: URL) throws {
        let file = try File(url: source, contentType: .zip)
        let data = try moodleData(forId: assignmentId)
        try uploadResponses(repoID: data.repoID, itemID: data.itemID, zippedItem: file)
        try importResponses(itemID: data.itemID, assignmentID: assignmentId)
        try confirmResponses(forId: assignmentId)
    }
    
    private func moodleDownloadURL(forId assignmentId: Int) -> URL {
        let moodlePath = MoodleSession.homeURL.absoluteString
        let downloadPath = "\(moodlePath)/mod/assign/view.php?id=\(assignmentId)&action=downloadall"
        return URL(string: downloadPath)!
    }
    
    private func moodleData(forId assignmentId: Int) throws -> (repoID: String, itemID: String) {
        let homeURL = MoodleSession.homeURL
        
        let path = """
        \(homeURL)/mod/assign/view.php?\
        id=\(assignmentId)&\
        plugin=file&\
        pluginsubtype=assignfeedback&\
        action=viewpluginpage&\
        pluginaction=uploadzip
        """
        
        let url = URL(string: path)!
        
        let content = try String(contentsOf: url)
        
        let itemIDPattern = "(?s).*\"itemid\":([0-9]+),.*"
        let repoIDPattern = "(?s).*\"repositories\":\\{\"[0-9]+\":\\{\"id\":\"([0-9]+)\"[^\\}]*\"type\":\"upload\".*"
        
        let repoID = try content.firstMatch(for: repoIDPattern, groupIndex: 1)
        let itemID = try content.firstMatch(for: itemIDPattern, groupIndex: 1)
        
        return (String(repoID), String(itemID))
    }
    
    private func uploadResponses(repoID: String, itemID: String, zippedItem: File) throws {
        var formdata = FormData()
        formdata.add(value: "upload", forKey: "action")
        formdata.add(value: session.info.sessionId, forKey: "sesskey")
        formdata.add(value: repoID, forKey: "repo_id")
        formdata.add(value: itemID, forKey: "itemid")
        formdata.add(value: "ppr ppr", forKey: "author")
        formdata.add(value: zippedItem.name, forKey: "title")
        formdata.add(file: zippedItem, forKey: "repo_upload_file")
        let uploadURL = MoodleSession.homeURL.appendingPathComponent("repository/repository_ajax.php")
        try formdata.post(to: uploadURL)
    }
    
    private func importResponses(itemID: String, assignmentID: Int) throws {
        var urldata = UrlEncodedData()
        urldata.add(value: String(assignmentID), forKey: "id")
        urldata.add(value: "viewpluginpage", forKey: "action")
        urldata.add(value: "uploadzip", forKey: "pluginaction")
        urldata.add(value: "file", forKey: "plugin")
        urldata.add(value: "assignfeedback", forKey: "pluginsubtype")
        urldata.add(value: session.info.sessionId, forKey: "sesskey")
        urldata.add(value: "1", forKey: "_qf__assignfeedback_file_upload_zip_form")
        urldata.add(value: "1", forKey: "mform_isexpanded_id_uploadzip")
        urldata.add(value: itemID, forKey: "feedbackzip")
        urldata.add(value: "Feedbackdatei(en) importieren", forKey: "submitbutton")
        let uploadURL = MoodleSession.homeURL.appendingPathComponent("mod/assign/view.php")
        try urldata.post(to: uploadURL)
    }
    
    public func confirmResponses(forId assignmentId: Int) throws {
        var urldata = UrlEncodedData()
        urldata.add(value: String(assignmentId), forKey: "id")
        urldata.add(value: "viewpluginpage", forKey: "action")
        urldata.add(value: "true", forKey: "confirm")
        urldata.add(value: "file", forKey: "plugin")
        urldata.add(value: "assignfeedback", forKey: "pluginsubtype")
        urldata.add(value: "uploadzip", forKey: "pluginaction")
        urldata.add(value: session.info.sessionId, forKey: "sesskey")
        urldata.add(value: "1", forKey: "_qf__assignfeedback_file_upload_zip_form")
        urldata.add(value: "1", forKey: "mform_isexpanded_id_uploadzip")
        let uploadURL = MoodleSession.homeURL.appendingPathComponent("mod/assign/view.php")
        try urldata.post(to: uploadURL)
    }
}
