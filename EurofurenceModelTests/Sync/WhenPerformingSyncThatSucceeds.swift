//
//  WhenPerformingSyncThatSucceeds.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenPerformingSyncThatSucceeds: XCTestCase {

    func testTheCompletionHandlerIsInvokedWithoutAnError() {
        let context = EurofurenceSessionTestBuilder().build()
        var invokedWithNilError = false
        context.refreshLocalStore { invokedWithNilError = $0 == nil }
        context.api.simulateSuccessfulSync(.randomWithoutDeletions)

        XCTAssertTrue(invokedWithNilError)
    }

    func testTheLongRunningTaskManagerIsToldToEndTaskBeganAtStartOfSync_AfterCompletionHandlerInvoked() {
        let context = EurofurenceSessionTestBuilder().build()
        var didFinishTaskBeforeCompletionHandlerReturned = false
        context.refreshLocalStore { (_) in didFinishTaskBeforeCompletionHandlerReturned = context.longRunningTaskManager.finishedTask }

        XCTAssertFalse(context.longRunningTaskManager.finishedTask)

        context.api.simulateSuccessfulSync(.randomWithoutDeletions)
        XCTAssertFalse(didFinishTaskBeforeCompletionHandlerReturned)
        XCTAssertTrue(context.longRunningTaskManager.finishedTask)
    }

    func testAllImagesAreDownloaded() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let expected = syncResponse.images.changed.map({ (image) -> ImageEntity in
            let imageData: Data? = context.api.stubbedImage(for: image.identifier, availableImages: syncResponse.images.changed)
            return ImageEntity(identifier: image.identifier,
                               pngImageData: imageData!)
        })

        XCTAssertTrue(context.imageRepository.didSave(expected))
    }

    func testCompleteTheSyncWhenNoImagesToDownload() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        syncResponse.images.changed = []
        let context = EurofurenceSessionTestBuilder().build()
        var didFinish = false
        context.refreshLocalStore { (_) in didFinish = true }
        context.api.simulateSuccessfulSync(syncResponse)

        XCTAssertTrue(didFinish)
    }

    func testTheDataStoreIsToldToSaveTheLastSyncDateTime() {
        let context = EurofurenceSessionTestBuilder().build()
        context.refreshLocalStore()
        let randomTime = Date.random
        context.clock.tickTime(to: randomTime)
        context.api.simulateSuccessfulSync(.randomWithoutDeletions)

        XCTAssertEqual(randomTime, context.dataStore.fetchLastRefreshDate())
    }

}
