import EurofurenceApplicationSession
import XCTest

class FirebaseTopicTests: XCTestCase {

    func testProvideAppropriateTopicNameForiOSTopic() {
        XCTAssertEqual("ios", FirebaseTopic.ios.description)
    }

    func testProvideAppropriateTopicNameForDebugTopic() {
        XCTAssertEqual("debug", FirebaseTopic.debug.description)
    }

    func testProvideAppropriateTopicNameForVersionTopic() {
        let version = "2.0.0"
        XCTAssertEqual("version-\(version)", FirebaseTopic.version(version).description)
    }

}
