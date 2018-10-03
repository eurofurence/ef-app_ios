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
        let factory = PhoneMessagesSceneFactory()
        let viewController = factory.makeMessagesScene()
        precondition(viewController is MessagesViewControllerV2)
        self.viewController = viewController as? MessagesViewControllerV2
        viewController.delegate = delegate
        viewController.loadViewIfNeeded()
    }
    
    private func makeAndBindCell() -> (binder: StubMessageItemBinder, cell: MessageTableViewCell?) {
        let binder = StubMessageItemBinder()
        binder.numberOfMessages = 1
        viewController.bindMessages(count: 1, with: binder)
        let firstIndexPath = IndexPath(row: 0, section: 0)
        let cell = viewController.tableView.cellForRow(at: firstIndexPath) as? MessageTableViewCell
        
        return (binder: binder, cell: cell)
    }
    
    func testTellsTheDelegateWhenViewWillAppear() {
        viewController.viewWillAppear(false)
        XCTAssertTrue(delegate.toldMessagesSceneWillAppear)
    }
    
    func testDoesNotTellTheDelegateTheViewWillAppearTooSoon() {
        XCTAssertFalse(delegate.toldMessagesSceneWillAppear)
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
        let randomIndexPath = IndexPath(row: .random, section: 0)
        viewController.tableView.delegate?.tableView?(viewController.tableView, didSelectRowAt: randomIndexPath)
        
        XCTAssertEqual(randomIndexPath, delegate.capturedSelectedMessageIndexPath)
    }
    
    func testBindingMessagesShouldUpdateNumberOfRowsInTableView() {
        let binder = StubMessageItemBinder()
        let messageCount = Int.random(upperLimit: 10)
        viewController.bindMessages(count: messageCount, with: binder)
        
        XCTAssertEqual(messageCount, viewController.tableView.numberOfRows(inSection: 0))
    }
    
    func testBindingAuthorSetsItOntoCell() {
        let author = "Author"
        let binding = makeAndBindCell()
        binding.binder.capturedScene?.presentAuthor(author)
        
        XCTAssertEqual(author, binding.cell?.messageAuthorLabel.text)
    }
    
    func testBindingSubjectSetsItOntoCell() {
        let subject = "Subject"
        let binding = makeAndBindCell()
        binding.binder.capturedScene?.presentSubject(subject)
        
        XCTAssertEqual(subject, binding.cell?.messageSubjectLabel.text)
    }
    
    func testBindingSynopsisSetsItOntoCell() {
        let synopsis = "Synopsis"
        let binding = makeAndBindCell()
        binding.binder.capturedScene?.presentContents(synopsis)
        
        XCTAssertEqual(synopsis, binding.cell?.messageSynopsisLabel.text)
    }
    
    func testBindingDateTimeSetsItOntoCell() {
        let dateTime = "Date Time"
        let binding = makeAndBindCell()
        binding.binder.capturedScene?.presentReceivedDateTime(dateTime)
        
        XCTAssertEqual(dateTime, binding.cell?.messageReceivedDateLabel.text)
    }
    
    func testTellingCellToShowUnreadIndicatorShowsIt() {
        let binding = makeAndBindCell()
        binding.binder.capturedScene?.showUnreadIndicator()
        
        XCTAssertEqual(false, binding.cell?.unreadMessageIndicator.isHidden)
    }
    
    func testTellingCellToHideUnreadIndicatorHidesIt() {
        let binding = makeAndBindCell()
        binding.binder.capturedScene?.hideUnreadIndicator()
        
        XCTAssertEqual(true, binding.cell?.unreadMessageIndicator.isHidden)
    }
    
    func testBindingMessagesShouldPassIndexPathOfCellToBinder() {
        let binder = StubMessageItemBinder()
        binder.numberOfMessages = 1
        viewController.bindMessages(count: 1, with: binder)
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
    
    func testSetsTheTitleOntoTheViewController() {
        let expected = "Messages"
        viewController.setMessagesTitle(expected)
        
        XCTAssertEqual(expected, viewController.title)
    }
    
    func testPerformingPullToRefreshActionTellsDelegate() {
        viewController.refreshIndicator.sendActions(for: .valueChanged)
        XCTAssertTrue(delegate.didPerformRefreshAction)
    }
    
    func testDelegateIsNotToldAboutPullToRefreshActionsWithoutThemHappening() {
        XCTAssertFalse(delegate.didPerformRefreshAction)
    }
    
}
