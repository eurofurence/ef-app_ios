//
//  ImagesRemoveAllBeforeInsertTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class ImagesRemoveAllBeforeInsertTests: XCTestCase {

    func testTellTheDataStoreToDeleteTheImages() {
        let originalResponse = APISyncResponse.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.images.removeAllBeforeInsert = true
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)

        XCTAssertEqual(originalResponse.images.changed.map({ $0.identifier }),
                       context.dataStore.transaction.deletedImages,
                       "Should have removed original images between sync events")
    }

    func testNotDeleteOriginalImagesWhenPurgeNotRequired() {
        let originalResponse = APISyncResponse.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.images.removeAllBeforeInsert = false
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)

        XCTAssertTrue(context.dataStore.transaction.deletedImages.isEmpty,
                      "Should not have removed original images between sync events")
    }

    func testRemoveImagesFromTheCache() {
        let originalResponse = APISyncResponse.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.images.removeAllBeforeInsert = true
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)

        XCTAssertEqual(originalResponse.images.changed.map({ $0.identifier }),
                       context.imageRepository.deletedImages,
                       "Should have removed original images between sync events")
    }

    func testNotRemoveImagesFromTheCacheWhenPurgeNotRequired() {
        let originalResponse = APISyncResponse.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.images.removeAllBeforeInsert = false
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)

        XCTAssertTrue(context.imageRepository.deletedImages.isEmpty,
                      "Should have not removed original images between sync events")
    }

    func testProduceExpectedImageDataForDealerUsingNewResponse() {
        let originalResponse = APISyncResponse.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.images.removeAllBeforeInsert = true
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)
        let randomDealer = subsequentResponse.dealers.changed.randomElement().element
        var data: ExtendedDealerData?
        context.application.fetchExtendedDealerData(for: DealerIdentifier(randomDealer.identifier)) { data = $0 }

        XCTAssertEqual(data?.artistImagePNGData, context.imageAPI.stubbedImage(for: randomDealer.artistImageId))
    }

}
