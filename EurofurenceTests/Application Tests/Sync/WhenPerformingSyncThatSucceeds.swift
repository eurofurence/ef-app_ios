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
        randomEvent.element.posterImageId = nil
        syncResponse.events.changed[randomEvent.index] = randomEvent.element
        let context = ApplicationTestBuilder().build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        
        let expected = syncResponse.events.changed.map({
            $0.posterImageId
        }).compactMap({
            $0
        }).map({
            ImageEntity(identifier: $0, pngImageData: context.imageAPI.stubbedImage(for: $0)!)
        })
        
        XCTAssertTrue(context.imageRepository.didSave(expected))
    }
    
    func testTheEventBannerImagesAreSavedIntoTheImageRepository() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        var randomEvent = syncResponse.events.changed.randomElement()
        randomEvent.element.bannerImageId = nil
        syncResponse.events.changed[randomEvent.index] = randomEvent.element
        let context = ApplicationTestBuilder().build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        
        let expected = syncResponse.events.changed.map({
            $0.bannerImageId
        }).compactMap({
            $0
        }).map({
            ImageEntity(identifier: $0, pngImageData: context.imageAPI.stubbedImage(for: $0)!)
        })
        
        XCTAssertTrue(context.imageRepository.didSave(expected))
    }
    
    func testCompleteTheSyncWhenAllEventsDoNotHaveImages() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        let changed = syncResponse.events.changed
        for (idx, event) in changed.enumerated() {
            var copy = event
            copy.posterImageId = nil
            syncResponse.events.changed[idx] = copy
        }
        
        let context = ApplicationTestBuilder().build()
        var didFinish = false
        context.refreshLocalStore() { (_) in didFinish = true }
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        
        XCTAssertTrue(didFinish)
    }
    
    func testTheDataStoreIsToldToSaveTheLastSyncDateTime() {
        let context = ApplicationTestBuilder().build()
        context.refreshLocalStore()
        let randomTime = Date.random
        context.clock.currentDate = randomTime
        context.syncAPI.simulateSuccessfulSync(.randomWithoutDeletions)
        
        XCTAssertTrue(context.dataStore.didSaveLastRefreshTime(randomTime))
    }
    
    func testTheDealerIconsAreSavedIntoTheImageRepository() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let context = ApplicationTestBuilder().build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        
        let expected = syncResponse.dealers.changed.map({
            $0.artistThumbnailImageId
        }).compactMap({
            $0
        }).map({
            ImageEntity(identifier: $0, pngImageData: context.imageAPI.stubbedImage(for: $0)!)
        })
        
        XCTAssertTrue(context.imageRepository.didSave(expected))
    }
    
}
