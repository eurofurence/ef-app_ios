//
//  WhenFetchingImagesForKnowledgeEntry_WhenEntryHasImages_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenFetchingImagesForKnowledgeEntry_WhenEntryHasImages_ApplicationShould: XCTestCase {
    
    func testProvideTheImageDataFromTheRepository() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let randomEntry = syncResponse.knowledgeEntries.changed.randomElement().element
        let images = randomEntry.imageIdentifiers
        let expected = images.compactMap(context.imageRepository.loadImage).map({ $0.pngImageData })
        var actual: [Data]?
        context.application.fetchImagesForKnowledgeEntry(identifier: KnowledgeEntry.Identifier(randomEntry.identifier)) { actual = $0 }
        
        XCTAssertEqual(expected, actual)
    }
    
}
