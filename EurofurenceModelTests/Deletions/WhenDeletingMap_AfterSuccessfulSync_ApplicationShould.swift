//
//  WhenDeletingMap_AfterSuccessfulSync_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenDeletingMap_AfterSuccessfulSync_ApplicationShould: XCTestCase {

    func testUpdateDelegateWithoutDeletedMap() {
        var response = ModelCharacteristics.randomWithoutDeletions
        let context = ApplicationTestBuilder().build()
        let delegate = CapturingMapsObserver()
        context.mapsService.add(delegate)
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let mapToDelete = response.maps.changed.randomElement()
        response.maps.changed = response.maps.changed.filter({ $0.identifier != mapToDelete.element.identifier })
        let expected = Set(response.maps.changed.map({ $0.identifier }))
        response.maps.changed.removeAll()
        response.maps.deleted.append(mapToDelete.element.identifier)
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let actual = Set(delegate.capturedMaps.map({ $0.identifier.rawValue }))

        XCTAssertEqual(expected, actual,
                       "Should have removed map \(mapToDelete.element.identifier)")
    }

}
