//
//  WhenPreparingViewModel_MapDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenPreparingViewModel_MapDetailInteractorShould: XCTestCase {
    
    func testPrepareViewModelWithTitleForSpecifiedMap() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let interactor = DefaultMapDetailInteractor(mapsService: mapsService)
        var viewModel: MapDetailViewModel?
        interactor.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }
        
        XCTAssertEqual(randomMap.element.location, viewModel?.mapName)
    }
    
}
