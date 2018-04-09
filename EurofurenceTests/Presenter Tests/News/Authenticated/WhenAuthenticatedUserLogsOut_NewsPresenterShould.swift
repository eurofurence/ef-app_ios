//
//  WhenAuthenticatedUserLogsOut_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenAuthenticatedUserLogsOut_NewsPresenterShould: XCTestCase {
    
    var context: NewsPresenterTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = NewsPresenterTestBuilder().withUser().build()
        context.simulateNewsSceneWillAppear()
        context.authService.notifyObserversUserDidLogout()
    }
    
    func testShowTheLoginNavigationAction() {
        XCTAssertTrue(context.newsScene.wasToldToShowLoginNavigationAction)
    }
    
    func testHideTheMessagesNavigationAction() {
        XCTAssertTrue(context.newsScene.wasToldToHideMessagesNavigationAction)
    }
    
    func testShowWelcomePrompt() {
        XCTAssertEqual(context.newsScene.capturedLoginPrompt, .anonymousUserLoginPrompt)
    }
    
}
