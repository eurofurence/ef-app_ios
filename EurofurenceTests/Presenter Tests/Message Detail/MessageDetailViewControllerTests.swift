//
//  MessageDetailViewControllerTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingMessageDetailSceneDelegate: MessageDetailSceneDelegate {
    
    private(set) var toldSceneWillAppear = false
    func messageDetailSceneWillAppear() {
        toldSceneWillAppear = true
    }
    
}

class MessageDetailViewControllerTests: XCTestCase {
    
    var delegate: CapturingMessageDetailSceneDelegate!
    var viewController: MessageDetailViewControllerV2!
    
    override func setUp() {
        super.setUp()
        
        delegate = CapturingMessageDetailSceneDelegate()
        viewController = PhoneMessageDetailSceneFactory().makeMessageDetailScene() as! MessageDetailViewControllerV2
        viewController.delegate = delegate
        viewController.loadViewIfNeeded()
    }
    
    func testViewControllerNotifiesWhenSceneWillAppear() {
        viewController.viewWillAppear(false)
        XCTAssertTrue(delegate.toldSceneWillAppear)
    }
    
    func testViewControllerDoesNotNotifySceneWillAppearTooSoon() {
        XCTAssertFalse(delegate.toldSceneWillAppear)
    }
    
    func testSettingTheMessageDetailTitleSetsTheViewControllersTitle() {
        let messageDetailTitle = "Message"
        viewController.setMessageDetailTitle(messageDetailTitle)
        
        XCTAssertEqual(messageDetailTitle, viewController.title)
    }
    
    func testTheCollectionViewShouldHaveOneItem() {
        XCTAssertEqual(1, viewController.collectionView.numberOfItems(inSection: 0))
    }
    
}
