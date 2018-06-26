//
//  WhenMapsSceneLoads_MapsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenMapsSceneLoads_MapsPresenterShould: XCTestCase {
    
    func testBindTheNumberOfMapsFromTheViewModel() {
        let viewModel = FakeMapsViewModel()
        let interactor = FakeMapsInteractor(viewModel: viewModel)
        let context = MapsPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(viewModel.numberOfMaps, context.scene.boundNumberOfMaps)
    }
    
}
