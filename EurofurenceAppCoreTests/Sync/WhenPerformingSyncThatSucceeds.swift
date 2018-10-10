//
//  WhenPerformingSyncThatSucceeds.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenPerformingSyncThatSucceeds: XCTestCase {
    
    func testTheCompletionHandlerIsInvokedWithoutAnError() {
        let context = ApplicationTestBuilder().build()
        var invokedWithNilError = false
        context.refreshLocalStore { invokedWithNilError = $0 == nil }
        context.syncAPI.simulateSuccessfulSync(.randomWithoutDeletions)
        
        XCTAssertTrue(invokedWithNilError)
    }
    
    func testTheLongRunningTaskManagerIsToldToEndTaskBeganAtStartOfSync_AfterCompletionHandlerInvoked() {
        let context = ApplicationTestBuilder().build()
        var didFinishTaskBeforeCompletionHandlerReturned = false
        context.refreshLocalStore() { (_) in didFinishTaskBeforeCompletionHandlerReturned = context.longRunningTaskManager.finishedTask }
        
        XCTAssertFalse(context.longRunningTaskManager.finishedTask)
        
        context.syncAPI.simulateSuccessfulSync(.randomWithoutDeletions)
        XCTAssertFalse(didFinishTaskBeforeCompletionHandlerReturned)
        XCTAssertTrue(context.longRunningTaskManager.finishedTask)
    }
    
    func testAllImagesAreDownloaded() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let expected = syncResponse.images.changed.map({ ImageEntity(identifier: $0.identifier, pngImageData: context.imageAPI.stubbedImage(for: $0.identifier)!) })
        
        XCTAssertTrue(context.imageRepository.didSave(expected))
    }
    
    func testCompleteTheSyncWhenNoImagesToDownload() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        syncResponse.images.changed = []
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
        context.clock.tickTime(to: randomTime)
        context.syncAPI.simulateSuccessfulSync(.randomWithoutDeletions)
        
        XCTAssertTrue(context.dataStore.didSaveLastRefreshTime(randomTime))
    }
    
}
