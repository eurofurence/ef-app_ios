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
    
    func messageDetailSceneDidLoad() {
        
    }
    
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
        viewController.view.layoutSubviews()
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
    
    func testSettingMessageSubjectSetsItOntoCell() {
        let cell = viewController.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? MessageBubbleCollectionViewCell
        let subject = "Subject"
        viewController.setMessageSubject(subject)
        
        XCTAssertEqual(subject, cell?.subjectLabel.text)
    }
    
    func testSettingMessageContentsSetsItOntoCell() {
        let cell = viewController.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? MessageBubbleCollectionViewCell
        let contents = "Subject"
        viewController.setMessageContents(contents)
        
        XCTAssertEqual(contents, cell?.messageLabel.text)
    }
    
}
