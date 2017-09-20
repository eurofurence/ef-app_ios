//
//  MessagesViewControllerTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class StubMessageItemBinder: MessageItemBinder {

    var numberOfMessages: Int = 0
    
    private(set) var capturedScene: MessageItemScene?
    private(set) var capturedIndexPath: IndexPath?
    func bind(_ scene: MessageItemScene, toMessageAt indexPath: IndexPath) {
        capturedScene = scene
        capturedIndexPath = indexPath
    }
    
}

class MessagesViewControllerTests: XCTestCase {
    
    var viewController: MessagesViewControllerV2!
    var delegate: CapturingMessagesSceneDelegate!
    
    override func setUp() {
        super.setUp()
        
        delegate = CapturingMessagesSceneDelegate()
        viewController = MessagesViewControllerV2(nibName: nil, bundle: nil)
        viewController.delegate = delegate
        viewController.loadViewIfNeeded()
    }
    
    func testTheRefreshIndicatorShouldBeEmbeddedWithinTheTableView() {
        XCTAssertTrue(viewController.refreshIndicator.isDescendant(of: viewController.tableView))
    }
    
    func testShowingTheRefreshIndicatorShouldTellItToBeginRefreshing() {
        viewController.showRefreshIndicator()
        XCTAssertTrue(viewController.refreshIndicator.isRefreshing)
    }
    
    func testHidingTheRefreshIndicatorShouldTellItToStopRefreshing() {
        viewController.refreshIndicator.beginRefreshing()
        viewController.hideRefreshIndicator()
        
        XCTAssertFalse(viewController.refreshIndicator.isRefreshing)
    }
    
    func testSelectingItemAtTableViewIndexPathTellsTheDelegateAboutIt() {
        let randomIndexPath = IndexPath(row: Random.makeRandomNumber(), section: 0)
        viewController.tableView.delegate?.tableView?(viewController.tableView, didSelectRowAt: randomIndexPath)
        
        XCTAssertEqual(randomIndexPath, delegate.capturedSelectedMessageIndexPath)
    }
    
    func testBindingMessagesShouldUpdateNumberOfRowsInTableView() {
        let binder = StubMessageItemBinder()
        binder.numberOfMessages = Random.makeRandomNumber(upperLimit: 10)
        viewController.bindMessages(with: binder)
        
        XCTAssertEqual(binder.numberOfMessages, viewController.tableView.numberOfRows(inSection: 0))
    }
    
    func testBindingMessagesShouldPassCellToBinder() {
        let binder = StubMessageItemBinder()
        binder.numberOfMessages = 1
        viewController.bindMessages(with: binder)
        let firstIndexPath = IndexPath(row: 0, section: 0)
        let cell = viewController.tableView.cellForRow(at: firstIndexPath)
        
        XCTAssertTrue((binder.capturedScene as? UITableViewCell) === cell)
    }
    
    func testBindingMessagesShouldPassIndexPathOfCellToBinder() {
        let binder = StubMessageItemBinder()
        binder.numberOfMessages = 1
        viewController.bindMessages(with: binder)
        let firstIndexPath = IndexPath(row: 0, section: 0)
        _ = viewController.tableView.cellForRow(at: firstIndexPath)
        
        XCTAssertEqual(firstIndexPath, binder.capturedIndexPath)
    }
    
    func testShowingMessagesListUnhidesTableView() {
        viewController.tableView.isHidden = true
        viewController.showMessagesList()
        
        XCTAssertFalse(viewController.tableView.isHidden)
    }
    
    func testHidingMessagesListHidesTableView() {
        viewController.tableView.isHidden = false
        viewController.hideMessagesList()
        
        XCTAssertTrue(viewController.tableView.isHidden)
    }
    
    func testShowingNoMessagesPlaceholderUnhidesThePlaceholderView() {
        viewController.noMessagesPlaceholder.isHidden = true
        viewController.showNoMessagesPlaceholder()
        
        XCTAssertFalse(viewController.noMessagesPlaceholder.isHidden)
    }
    
    func testHidingNoMessagesPlaceholderHidesThePlaceholderView() {
        viewController.noMessagesPlaceholder.isHidden = false
        viewController.hideNoMessagesPlaceholder()
        
        XCTAssertTrue(viewController.noMessagesPlaceholder.isHidden)
    }
    
}
