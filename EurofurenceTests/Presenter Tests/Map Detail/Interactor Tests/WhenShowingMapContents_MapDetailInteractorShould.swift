//
//  WhenShowingMapContents_MapDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenShowingMapContents_MapDetailInteractorShould: XCTestCase {
    
    func testTellTheServiceToShowMapContentsAtPositionForIdentifier() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let interactor = DefaultMapDetailInteractor(mapsService: mapsService)
        var viewModel: MapDetailViewModel?
        interactor.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }
        let location = (x: Float.random, y: Float.random)
        viewModel?.showContentsAtPosition(x: location.x, y: location.y)
        
        XCTAssertEqual(randomMap.element.identifier, mapsService.capturedIdentifierForShowingMapContents)
        XCTAssertEqual(location.x, mapsService.capturedXPositionForShowingMapContents)
        XCTAssertEqual(location.y, mapsService.capturedYPositionForShowingMapContents)
    }
    
}
