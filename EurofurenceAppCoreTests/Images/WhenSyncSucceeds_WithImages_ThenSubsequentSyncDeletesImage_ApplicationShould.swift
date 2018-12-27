//
//  WhenSyncSucceeds_WithImages_ThenSubsequentSyncDeletesImage_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 29/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenSyncSucceeds_WithImages_ThenSubsequentSyncDeletesImage_ApplicationShould: XCTestCase {

    func testDeleteTheImageFromTheStore() {
        let dataStore = CapturingEurofurenceDataStore()
        let context = ApplicationTestBuilder().with(dataStore).build()
        var syncResponse = APISyncResponse.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
        let imageToDelegate = syncResponse.images.changed.randomElement().element
        syncResponse.images.changed.removeAll()
        syncResponse.images.deleted = [imageToDelegate.identifier]
        context.performSuccessfulSync(response: syncResponse)

        XCTAssertTrue(dataStore.transaction.deletedImages.contains(imageToDelegate.identifier))
        XCTAssertTrue(context.imageRepository.deletedImages.contains(imageToDelegate.identifier))
    }

}
