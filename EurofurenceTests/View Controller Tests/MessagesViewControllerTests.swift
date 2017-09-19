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
    
    private func makeMessageViewModel(author: String = "Title",
                                      formattedReceivedDate: String = "Received",
                                      subject: String = "Subject",
                                      isRead: Bool = true) -> MessageViewModel {
        return MessageViewModel(author: author,
                                formattedReceivedDate: formattedReceivedDate,
                                subject: subject,
                                isRead: isRead)
    }
    
    private func showMessage(_ viewModel: MessageViewModel) -> MessageTableViewCell {
        let viewModel = MessagesViewModel(childViewModels: [viewModel])
        viewController.showMessages(viewModel)
        
        return viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MessageTableViewCell
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
    
    func testUpdatingSceneWithViewModelShouldLaterDequeueCellWithAuthorFromViewModel() {
        let author = "Message title"
        let messageViewModel = makeMessageViewModel(author: author)
        let cell = showMessage(messageViewModel)
        
        XCTAssertEqual(author, cell.messageAuthorLabel.text)
    }
    
    func testUpdatingSceneWithViewModelShouldLaterDequeueCellWithFormattedReceivedDateFromViewModel() {
        let receivedDate = "From the future"
        let messageViewModel = makeMessageViewModel(formattedReceivedDate: receivedDate)
        let cell = showMessage(messageViewModel)
        
        XCTAssertEqual(receivedDate, cell.messageReceivedDateLabel.text)
    }
    
    func testUpdatingSceneWithViewModelShouldLaterDequeueCellWithSubjectFromViewModel() {
        let subject = "You won!"
        let messageViewModel = makeMessageViewModel(subject: subject)
        let cell = showMessage(messageViewModel)
        
        XCTAssertEqual(subject, cell.messageSubjectLabel.text)
    }
    
    func testUpdatingSceneWithViewModelShouldLaterDequeueCellHidingTheUnreadIndicatorForReadMessage() {
        let messageViewModel = makeMessageViewModel(isRead: true)
        let cell = showMessage(messageViewModel)
        
        XCTAssertTrue(cell.unreadMessageIndicator.isHidden)
    }
    
    func testUpdatingSceneWithViewModelShouldLaterDequeueCellShowingTheUnreadIndicatorForUnreadMessage() {
        let messageViewModel = makeMessageViewModel(isRead: false)
        let cell = showMessage(messageViewModel)
        
        XCTAssertFalse(cell.unreadMessageIndicator.isHidden)
    }
    
}
