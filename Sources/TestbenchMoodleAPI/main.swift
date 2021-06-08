import Foundation
import SwiftSoup

let username = ""
let password = ""
let destination = URL(fileURLWithPath: "/Users/Simon/Downloads")

enum Assignments: Int {
    case ulam = 129974
    case determinante = 129975
    case gameOfLife = 129976
}

let assignmentId = Assignments.determinante.rawValue

if let session = MoodleSession(name: username, password: password) {
    let application = MoodleApplication(session: session)
    let submissions = try application.downloadSubmissions(forId: assignmentId, to: destination)
    
    for submission in submissions {
        print(submission.studentName)
    }
}
