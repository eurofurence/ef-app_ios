//
//  MessagesViewControllerTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

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
    
    func testUpdatingSceneWithViewModelShouldUpdateNumberOfRowsInTableView() {
        let randomMessageCount = Random.makeRandomNumber(upperLimit: 10)
        let messages = Array(repeating: AppDataBuilder.makeMessage(), count: randomMessageCount)
        let viewModel = MessagesViewModel(messages: messages)
        viewController.showMessages(viewModel)
        
        XCTAssertEqual(randomMessageCount, viewController.tableView.numberOfRows(inSection: 0))
    }
    
    func testUpdatingSceneWithViewModelShouldLaterDequeueCellWithTitleFromViewModel() {
        let title = "Message title"
        let messageViewModel = MessageViewModel(title: title)
        let viewModel = MessagesViewModel(childViewModels: [messageViewModel])
        viewController.showMessages(viewModel)
        let cell = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MessageTableViewCell
        
        XCTAssertEqual(title, cell.messageTitleLabel.text)
    }
    
}
