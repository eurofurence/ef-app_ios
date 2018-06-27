//
//  WhenMapDetailSceneLoads_MapsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenMapDetailSceneLoads_MapsPresenterShould: XCTestCase {
    
    func testBindTheMapFromTheViewModelOntoTheScene() {
        let identifier = Map2.Identifier.random
        let interactor = FakeMapDetailInteractor(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(interactor).build(for: identifier)
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(interactor.viewModel.mapImagePNGData, context.scene.capturedMapImagePNGData)
    }
    
}
