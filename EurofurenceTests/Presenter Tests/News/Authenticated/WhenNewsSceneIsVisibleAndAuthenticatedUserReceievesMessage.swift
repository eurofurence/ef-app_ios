//
//  WhenNewsSceneIsVisibleAndAuthenticatedUserReceievesMessage.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenNewsSceneIsVisibleAndAuthenticatedUserReceievesMessage: XCTestCase {
    
    func testTheUnreadCountDescriptionIsSetOntoTheScene() {
        let context = NewsPresenterTestBuilder().withUser().build()
        context.simulateNewsSceneWillAppear()
        let messageCount = Int.random
        context.privateMessagesService.notifyUnreadCountDidChange(to: messageCount)
        
        XCTAssertEqual(context.newsScene.capturedWelcomeDescription, .welcomeDescription(messageCount: messageCount))
    }
    
}
