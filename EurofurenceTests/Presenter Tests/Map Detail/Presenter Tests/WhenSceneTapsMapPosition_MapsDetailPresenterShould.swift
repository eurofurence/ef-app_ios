//
//  WhenSceneTapsMapPosition_MapsDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCore
import XCTest

class WhenSceneTapsMapPosition_MapsDetailPresenterShould: XCTestCase {
    
    func testTellTheViewModelToShowTheMapContentsAtTheTappedLocation() {
        let identifier = Map2.Identifier.random
        let interactor = FakeMapDetailInteractor(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(interactor).build(for: identifier)
        context.simulateSceneDidLoad()
        let randomLocation = MapCoordinate(x: Float.random, y: Float.random)
        context.simulateSceneDidDidTapMap(at: randomLocation)
        
        XCTAssertEqual(randomLocation.x, interactor.viewModel.positionToldToShowMapContentsFor?.x)
        XCTAssertEqual(randomLocation.y, interactor.viewModel.positionToldToShowMapContentsFor?.y)
    }
    
}
