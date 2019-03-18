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
        let originalResponse = ModelCharacteristics.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.images.removeAllBeforeInsert = true
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)

        XCTAssertEqual(subsequentResponse.images.changed, context.dataStore.fetchImages(),
                       "Should have removed original images between sync events")
    }

    func testNotDeleteOriginalImagesWhenPurgeNotRequired() {
        let originalResponse = ModelCharacteristics.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.images.removeAllBeforeInsert = false
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        let imagesAfterFirstSync = context.dataStore.fetchImages()
        context.performSuccessfulSync(response: subsequentResponse)
        let imagesAfterSecondSync = context.dataStore.fetchImages()

        XCTAssertEqual(imagesAfterFirstSync, imagesAfterSecondSync,
                      "Should not have removed original images between sync events")
    }

    func testRemoveImagesFromTheCache() {
        let originalResponse = ModelCharacteristics.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.images.removeAllBeforeInsert = true
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)

        XCTAssertEqual(originalResponse.images.changed.identifiers,
                       context.imageRepository.deletedImages,
                       "Should have removed original images between sync events")
    }

    func testNotRemoveImagesFromTheCacheWhenPurgeNotRequired() {
        let originalResponse = ModelCharacteristics.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.images.removeAllBeforeInsert = false
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)

        XCTAssertTrue(context.imageRepository.deletedImages.isEmpty,
                      "Should have not removed original images between sync events")
    }

    func testProduceExpectedImageDataForDealerUsingNewResponse() {
        let originalResponse = ModelCharacteristics.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.images.removeAllBeforeInsert = true
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)
        let randomDealerCharacteristics = subsequentResponse.dealers.changed.randomElement().element
        let artistImageId = randomDealerCharacteristics.artistImageId
        
        let randomDealerEntity = context.dealersService.fetchDealer(for: DealerIdentifier(randomDealerCharacteristics.identifier))
        var data: ExtendedDealerData?
        randomDealerEntity?.fetchExtendedDealerData { data = $0 }
        let stubbedImage = context.api.stubbedImage(for: artistImageId, availableImages: originalResponse.images.changed)

        XCTAssertEqual(data?.artistImagePNGData, stubbedImage)
    }

}
