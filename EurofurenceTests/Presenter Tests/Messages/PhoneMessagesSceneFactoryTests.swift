//
//  PhoneMessagesSceneFactoryTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class PhoneMessagesSceneFactoryTests: XCTestCase {
    
    func testTheNewsViewControllerIsMade() {
        let factory = PhoneMessagesSceneFactory()
        XCTAssertTrue(factory.makeMessagesScene() is MessagesViewControllerV2)
    }
    
}
