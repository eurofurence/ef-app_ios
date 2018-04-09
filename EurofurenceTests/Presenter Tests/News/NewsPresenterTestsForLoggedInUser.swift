//
//  NewsPresenterTestsForLoggedInUser.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class NewsPresenterTestsForLoggedInUser: XCTestCase {
    
    func testWhenTheShowMessagesActionIsTappedTheShowMessagesCommandIsRan() {
        let context = NewsPresenterTestBuilder().withUser().build()
        context.newsScene.tapShowMessagesAction()
        
        XCTAssertTrue(context.delegate.showPrivateMessagesRequested)
    }
    
    func testWhenPrivateMessagesReloadsTheUnreadCountDescriptionIsSetOntoTheScene() {
        let context = NewsPresenterTestBuilder().withUser().build()
        context.simulateNewsSceneWillAppear()
        let messageCount = Int.random
        context.privateMessagesService.notifyUnreadCountDidChange(to: messageCount)
        
        XCTAssertEqual(context.newsScene.capturedWelcomeDescription, .welcomeDescription(messageCount: messageCount))
    }
    
    func testUpdatingUnreadCountBeforeSceneAppearsDoesNotUpdateLabel() {
        let context = NewsPresenterTestBuilder().withUser().build()
        context.privateMessagesService.notifyUnreadCountDidChange(to: 0)
        
        XCTAssertNil(context.newsScene.capturedWelcomeDescription)
    }
    
}
