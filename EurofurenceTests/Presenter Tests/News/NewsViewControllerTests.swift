//
//  NewsViewControllerTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingNewsSceneDelegate: NewsSceneDelegate {
    
    private(set) var loginActionTapped = false
    func newsSceneDidTapLoginAction(_ scene: NewsScene) {
        loginActionTapped = true
    }
    
    func newsSceneDidTapShowMessagesAction(_ scene: NewsScene) {
        
    }
    
}

class NewsViewControllerTests: XCTestCase {
    
    var viewController: NewsViewController!
    var delegate: CapturingNewsSceneDelegate!
    
    override func setUp() {
        super.setUp()
        
        viewController = PhoneNewsSceneFactory().makeNewsScene() as! NewsViewController
        delegate = CapturingNewsSceneDelegate()
        viewController.delegate = delegate
        viewController.loadViewIfNeeded()
    }
    
    func testHideLoginNavigationActionByDefault() {
        XCTAssertTrue(viewController.loginNavigationAction.isHidden)
    }
    
    func testShowLoginNavigationActionWhenToldTo() {
        viewController.showLoginNavigationAction()
        XCTAssertFalse(viewController.loginNavigationAction.isHidden)
    }
    
    func testHideLoginNavigationActionWhenToldTo() {
        viewController.showLoginNavigationAction()
        viewController.hideLoginNavigationAction()
        
        XCTAssertTrue(viewController.loginNavigationAction.isHidden)
    }
    
    func testTellDelegateWhenTappingLoginAction() {
        viewController.loginNavigationTrigger.sendActions(for: .touchUpInside)
        XCTAssertTrue(delegate.loginActionTapped)
    }
    
    func testNotTellDelegateLoginActionTappedTooEarly() {
        XCTAssertFalse(delegate.loginActionTapped)
    }
    
}
