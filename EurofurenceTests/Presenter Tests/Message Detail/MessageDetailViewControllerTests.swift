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
    
    private(set) var toldSceneDidLoad = false
    func messageDetailSceneDidLoad() {
        toldSceneDidLoad = true
    }
    
}

class CapturingMessageComponentBinder: MessageComponentBinder {
    
    private(set) var capturedMessageComponent: MessageComponent?
    func bind(_ component: MessageComponent) {
        capturedMessageComponent = component
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
    }
    
    private func loadView() {
        viewController.loadViewIfNeeded()
        viewController.view.layoutSubviews()
    }
    
    func testNotifiesWhenViewDidLoad() {
        loadView()
        XCTAssertTrue(delegate.toldSceneDidLoad)
    }
    
    func testDoesNotNotifyViewDidLoadTooEarly() {
        XCTAssertFalse(delegate.toldSceneDidLoad)
    }
    
    func testSettingTheMessageDetailTitleSetsTheViewControllersTitle() {
        let messageDetailTitle = "Message"
        loadView()
        viewController.setMessageDetailTitle(messageDetailTitle)
        
        XCTAssertEqual(messageDetailTitle, viewController.title)
    }
    
    func testBindingSubjectSetsItOntoCell() {
        loadView()
        let binder = CapturingMessageComponentBinder()
        viewController.addMessageComponent(with: binder)
        viewController.view.layoutSubviews()
        
        let cell = viewController.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? MessageBubbleCollectionViewCell
        let subject = "Subject"
        binder.capturedMessageComponent?.setMessageSubject(subject)
        
        XCTAssertEqual(subject, cell?.subjectLabel.text)
    }
    
    func testSettingMessageContentsSetsItOntoCell() {
        loadView()
        let binder = CapturingMessageComponentBinder()
        viewController.addMessageComponent(with: binder)
        viewController.view.layoutSubviews()
        
        let cell = viewController.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? MessageBubbleCollectionViewCell
        let contents = "Subject"
        binder.capturedMessageComponent?.setMessageContents(contents)
        
        XCTAssertEqual(contents, cell?.messageLabel.text)
    }
    
}
