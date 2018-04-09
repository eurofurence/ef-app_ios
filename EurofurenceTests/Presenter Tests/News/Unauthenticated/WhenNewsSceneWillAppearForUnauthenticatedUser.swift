//
//  WhenNewsSceneWillAppearForUnauthenticatedUser.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenNewsSceneWillAppearForUnauthenticatedUser: XCTestCase {
    
    var context: NewsPresenterTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = NewsPresenterTestBuilder().build()
        context.simulateNewsSceneWillAppear()
    }
    
    func testTheSceneIsToldToShowTheLoginNavigationAction() {
        XCTAssertTrue(context.newsScene.wasToldToShowLoginNavigationAction)
    }
    
    func testTheSceneIsToldToHideTheMessagesNavigationAction() {
        XCTAssertTrue(context.newsScene.wasToldToHideMessagesNavigationAction)
    }
    
    func testTheNewsSceneIsToldToShowWelcomePrompt() {
        XCTAssertEqual(context.newsScene.capturedLoginPrompt, .anonymousUserLoginPrompt)
    }
    
    func testTheNewsSceneIsToldToShowWelcomeDescription() {
        XCTAssertEqual(context.newsScene.capturedLoginDescription, .anonymousUserLoginDescription)
    }
    
}
