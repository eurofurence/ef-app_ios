import Eurofurence
import XCTest

class FirebaseTopicTests: XCTestCase {

    func testProvideAppropriateTopicNameForTestTopic() {
        XCTAssertEqual("test", FirebaseTopic.test.description)
    }

    func testProvideAppropriateTopicNameForLiveTopic() {
        XCTAssertEqual("live", FirebaseTopic.live.description)
    }

    func testProvideAppropriateTopicNameForiOSTopic() {
        XCTAssertEqual("ios", FirebaseTopic.ios.description)
    }

    func testProvideAppropriateTopicNameForDebugTopic() {
        XCTAssertEqual("debug", FirebaseTopic.debug.description)
    }

    func testProvideAppropriateTopicNameForVersionTopic() {
        let version = "2.0.0"
        XCTAssertEqual("Version-\(version)", FirebaseTopic.version(version).description)
    }

}
