//
//  MessageDetailViewControllerTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class MessageDetailViewControllerTests: XCTestCase {
    
    func testSettingTheMessageDetailTitleSetsTheViewControllersTitle() {
        let viewController = PhoneMessageDetailSceneFactory().makeMessageDetailScene() as! MessageDetailViewControllerV2
        viewController.loadViewIfNeeded()
        let messageDetailTitle = "Message"
        viewController.setMessageDetailTitle(messageDetailTitle)
        
        XCTAssertEqual(messageDetailTitle, viewController.title)
    }
    
}
