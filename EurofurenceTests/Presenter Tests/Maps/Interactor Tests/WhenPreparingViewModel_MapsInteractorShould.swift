//
//  WhenPreparingViewModel_MapsInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenPreparingViewModel_MapsInteractorShould: XCTestCase {
    
    func testAdaptNumberOfMapsFromServiceIntoMapsCount() {
        let mapsService = FakeMapsService()
        let interactor = DefaultMapsInteractor(mapsService: mapsService)
        var viewModel: MapsViewModel?
        interactor.makeMapsViewModel { viewModel = $0 }
        
        XCTAssertEqual(mapsService.maps.count, viewModel?.numberOfMaps)
    }
    
}
