import Foundation
import SwiftSoup

let username = ""
let password = ""

let destination = URL(fileURLWithPath: "/Users/Simon/Downloads")

if let session = MoodleSession(name: username, password: password) {
    let application = MoodleApplication(session: session)
    let _ = try application.downloadSubmissions(forId: 129974, to: destination)
}



