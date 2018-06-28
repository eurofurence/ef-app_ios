//
//  WhenShowingMapContents_ForAlternativeMapPosition_MapDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 28/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenShowingMapContents_ForAlternativeMapPosition_MapDetailInteractorShould: XCTestCase {
    
    func testConvertTheLocationIntoMapCoordinate() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let interactor = DefaultMapDetailInteractor(mapsService: mapsService)
        var viewModel: MapDetailViewModel?
        interactor.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }
        
        let (x, y) = (Float.random, Float.random)
        let (expectedX, expectedY) = (Float.random, Float.random)
        let expected = MapCoordinate(x: expectedX, y: expectedY)
        let visitor = CapturingMapContentVisitor()
        viewModel?.showContentsAtPosition(x: x, y: y, describingTo: visitor)
        mapsService.resolveMapContents(identifier: randomMap.element.identifier, atX: x, y: y, with: .location(x: expectedX, y: expectedY))
        
        XCTAssertEqual(expected, visitor.capturedMapCoordinate)
    }
    
}
