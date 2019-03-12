//
//  WhenFetchingMapImageData_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenFetchingMapImageData_ApplicationShould: XCTestCase {

    func testReturnTheDataForTheMapsImageIdentifier() {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
        let randomMap = syncResponse.maps.changed.randomElement()
        var mapImageData: Data?
        context.mapsService.fetchImagePNGDataForMap(identifier: MapIdentifier(randomMap.element.identifier)) { mapImageData = $0 }
        let imageEntity = context.imageRepository.loadImage(identifier: randomMap.element.imageIdentifier)

        XCTAssertEqual(imageEntity?.pngImageData, mapImageData)
    }

}
