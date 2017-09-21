//
//  MessageTableViewCellTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class MessageTableViewCellTests: XCTestCase {
    
    var cell: MessageTableViewCell!
    
    override func setUp() {
        super.setUp()
        
        let nib = UINib(nibName: "MessageTableViewCell", bundle: Bundle(for: MessageTableViewCell.self))
        cell = nib.instantiate(withOwner: nil, options: nil).first as! MessageTableViewCell
    }
    
    func testThePresentedAuthorShouldBeSetOntoTheAuthorLabel() {
        let author = "Author"
        cell.presentAuthor(author)
        
        XCTAssertEqual(author, cell.messageAuthorLabel.text)
    }
    
    func testThePresentedSubjectShouldBetSetOntoTheSubjectLabel() {
        let subject = "Subject"
        cell.presentSubject(subject)
        
        XCTAssertEqual(subject, cell.messageSubjectLabel.text)
    }
    
    func testThePresentedContentsShouldBeSetOntoTheSynopsisLabel() {
        let contents = "Contents"
        cell.presentContents(contents)
        
        XCTAssertEqual(contents, cell.messageSynopsisLabel.text)
    }
    
    func testThePresentedReceivedDateTimeShouldBeSetOntoTheReceivedDateTimeLabel() {
        let receivedDateTime = "Date"
        cell.presentReceivedDateTime(receivedDateTime)
        
        XCTAssertEqual(receivedDateTime, cell.messageReceivedDateLabel.text)
    }
    
}
