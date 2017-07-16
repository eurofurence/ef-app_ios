//
//  FirebaseTopicTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 16/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class FirebaseTopicTests: XCTestCase {
    
    func testProvideAppropriateTopicNameForTestTopic() {
        XCTAssertEqual("test", FirebaseTopic.test.rawValue)
    }
    
    func testProvideAppropriateTopicNameForLiveTopic() {
        XCTAssertEqual("live", FirebaseTopic.live.rawValue)
    }
    
    func testProvideAppropriateTopicNameForAnnouncementsTopic() {
        XCTAssertEqual("announcements", FirebaseTopic.announcements.rawValue)
    }
    
    func testProvideAppropriateTopicNameForiOSTopic() {
        XCTAssertEqual("ios", FirebaseTopic.ios.rawValue)
    }
    
    func testProvideAppropriateTopicNameForDebugTopic() {
        XCTAssertEqual("debug", FirebaseTopic.debug.rawValue)
    }
    
}
