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
    
    private(set) var toldNewsSceneWillAppear = false
    func newsSceneWillAppear() {
        toldNewsSceneWillAppear = true
    }
    
    func newsSceneDidSelectComponent(at indexPath: IndexPath) {
        
    }
    
    private(set) var loginActionTapped = false
    func newsSceneDidTapLoginAction(_ scene: NewsScene) {
        loginActionTapped = true
    }
    
    private(set) var messagesActionTapped = false
    func newsSceneDidTapShowMessagesAction(_ scene: NewsScene) {
        messagesActionTapped = true
    }
    
}

class NewsViewControllerTests: XCTestCase {
    
    var viewController: NewsViewController!
    var delegate: CapturingNewsSceneDelegate!
    
    override func setUp() {
        super.setUp()
        
        viewController = StoryboardNewsSceneFactory().makeNewsScene() as! NewsViewController
        delegate = CapturingNewsSceneDelegate()
        viewController.delegate = delegate
        viewController.loadViewIfNeeded()
    }
    
    func testSeatsBannerIntoTableViewHeader() {
        XCTAssertEqual(viewController.tableView.tableHeaderView, viewController.bannerContainer)
    }
    
    func testTellsTheDelegateWhenTheSceneWillAppear() {
        viewController.viewWillAppear(false)
        XCTAssertTrue(delegate.toldNewsSceneWillAppear)
    }
    
    func testDoesNotTellTleDelegateTheSceneWillAppearTooEarly() {
        XCTAssertFalse(delegate.toldNewsSceneWillAppear)
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
    
    func testHideMessagesNavigationActionByDefault() {
        XCTAssertTrue(viewController.messagesNavigationAction.isHidden)
    }
    
    func testShowMessagesNavigationActionWhenToldTo() {
        viewController.showMessagesNavigationAction()
        XCTAssertFalse(viewController.messagesNavigationAction.isHidden)
    }
    
    func testHideMessagesNavigationActionWhenToldTo() {
        viewController.showMessagesNavigationAction()
        viewController.hideMessagesNavigationAction()
        
        XCTAssertTrue(viewController.messagesNavigationAction.isHidden)
    }
    
    func testTellDelegateWhenTappingMessagesNavigationAction() {
        viewController.messagesNavigationTrigger.sendActions(for: .touchUpInside)
        XCTAssertTrue(delegate.messagesActionTapped)
    }
    
    func testNotTellDelegateMessagesNavigationActionTappedTooEarly() {
        XCTAssertFalse(delegate.messagesActionTapped)
    }
    
    func testSetWelcomePromptOntoWelcomePromptLabel() {
        let prompt = String.random
        viewController.showWelcomePrompt(prompt)
        
        XCTAssertEqual(prompt, viewController.welcomePromptLabel.text)
    }
    
    func testSetWelcomeDescriptionOntoWelcomeDescriptionLabel() {
        let description = String.random
        viewController.showWelcomeDescription(description)
        
        XCTAssertEqual(description, viewController.welcomeDescriptionLabel.text)
    }
    
    func testSetLoginPromptOntoLoginPromptLabel() {
        let prompt = String.random
        viewController.showLoginPrompt(prompt)
        
        XCTAssertEqual(prompt, viewController.loginPromptLabel.text)
    }
    
    func testSetLoginDescriptionOntoLoginDescriptionLabel() {
        let description = String.random
        viewController.showLoginDescription(description)
        
        XCTAssertEqual(description, viewController.loginPromptDescriptionLabel.text)
    }
    
}
