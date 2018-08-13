//
//  ImagesRemoveAllBeforeInsertTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class ImagesRemoveAllBeforeInsertTests: XCTestCase {
    
    func testTellTheDataStoreToDeleteTheImages() {
        let originalResponse = APISyncResponse.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.maps.removeAllBeforeInsert = true
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
        subsequentResponse.maps.removeAllBeforeInsert = false
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)
        
        XCTAssertTrue(context.dataStore.transaction.deletedImages.isEmpty,
                      "Should not have removed original images between sync events")
    }
    
    func testRemoveImagesFromTheCache() {
        let originalResponse = APISyncResponse.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.maps.removeAllBeforeInsert = true
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
        subsequentResponse.maps.removeAllBeforeInsert = false
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)
        
        XCTAssertTrue(context.imageRepository.deletedImages.isEmpty,
                      "Should have not removed original images between sync events")
    }
    
}
