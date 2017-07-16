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
        XCTAssertEqual("test", FirebaseTopic.test.description)
    }
    
    func testProvideAppropriateTopicNameForLiveTopic() {
        XCTAssertEqual("live", FirebaseTopic.live.description)
    }
    
    func testProvideAppropriateTopicNameForAnnouncementsTopic() {
        XCTAssertEqual("announcements", FirebaseTopic.announcements.description)
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
