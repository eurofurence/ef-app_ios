//
//  WhenPerformingSyncThatSucceeds.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenPerformingSyncThatSucceeds: XCTestCase {
    
    func testTheKnowledgeGroupsArePersistedIntoTheStore() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let expected = KnowledgeGroup2.fromServerModels(groups: syncResponse.knowledgeGroups.changed, entries: syncResponse.knowledgeEntries.changed)
        
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        
        XCTAssertTrue(context.dataStore.didSave(expected))
    }
    
    func testTheAnnouncementsArePersistedToTheStore() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let expected = Announcement2.fromServerModels(syncResponse.announcements.changed)
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        
        XCTAssertTrue(context.dataStore.didSave(expected))
    }
    
    func testTheCompletionHandlerIsInvokedWithoutAnError() {
        let context = ApplicationTestBuilder().build()
        var invokedWithNilError = false
        context.refreshLocalStore { invokedWithNilError = $0 == nil }
        context.syncAPI.simulateSuccessfulSync(.randomWithoutDeletions)
        
        XCTAssertTrue(invokedWithNilError)
    }
    
    func testTheEventPosterImagesAreSavedIntoTheImageRepository() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        var randomEvent = syncResponse.events.changed.randomElement()
        randomEvent.element.posterImageId = ""
        syncResponse.events.changed[randomEvent.index] = randomEvent.element
        let context = ApplicationTestBuilder().build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        
        let expected = syncResponse.events.changed.map({
            $0.posterImageId
        }).filter({
            !$0.isEmpty
        }).map({
            ImageEntity(identifier: $0, pngImageData: context.imageAPI.stubbedImage(for: $0))
        })
        
        XCTAssertEqual(expected, context.imageRepository.savedImages)
    }
    
}
