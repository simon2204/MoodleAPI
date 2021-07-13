import XCTest
import class Foundation.Bundle
@testable import MoodleAPI

final class MoodleAPITests: XCTestCase {
    func testExample() async throws {
        let session = try MoodleSession(name: "", password: "")
        let application = MoodleApplication(session: session)
        let url = URL(fileURLWithPath: "/Users/simon/Desktop/feedback.zip")
        try application.uploadFeedbackZIP(forId: 82893, from: url)
    }
}
