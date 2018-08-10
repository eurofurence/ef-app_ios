//
//  WhenSyncSucceeds_ForEmptyDataStore_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 05/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenSyncSucceeds_ForEmptyDataStore_ApplicationShould: XCTestCase {
    
    var context: ApplicationTestBuilder.Context!
    var syncResponse: APISyncResponse!
    
    override func setUp() {
        super.setUp()
        
        context = ApplicationTestBuilder().build()
        syncResponse = APISyncResponse.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
    }
    
    func testSaveTheKnowledgeGroupsIntoTheStore() {
        let expected = syncResponse.knowledgeGroups.changed
        XCTAssertTrue(context.dataStore.didSave(expected))
    }
    
    func testSaveTheKnowledgeEntriesIntoTheStore() {
        let expected = syncResponse.knowledgeEntries.changed
        XCTAssertTrue(context.dataStore.didSave(expected))
    }
    
    func testSaveTheAnnouncementsIntoToTheStore() {
        let expected = syncResponse.announcements.changed
        XCTAssertTrue(context.dataStore.didSave(expected))
    }
    
    func testSaveTheEventsIntoToTheStore() {
        let expected = syncResponse.events.changed
        XCTAssertTrue(context.dataStore.didSave(expected))
    }
    
    func testSaveTheRoomsIntoToTheStore() {
        let expected = syncResponse.rooms.changed
        XCTAssertTrue(context.dataStore.didSave(expected))
    }
    
    func testSaveTheTracksIntoToTheStore() {
        let expected = syncResponse.tracks.changed
        XCTAssertTrue(context.dataStore.didSave(expected))
    }
    
    func testSaveTheDealersIntoTheStore() {
        let expected = syncResponse.dealers.changed
        XCTAssertTrue(context.dataStore.didSave(expected))
    }
    
    func testSaveTheMapsIntoTheStore() {
        let expected = syncResponse.maps.changed
        XCTAssertTrue(context.dataStore.didSave(expected))
    }
    
}
