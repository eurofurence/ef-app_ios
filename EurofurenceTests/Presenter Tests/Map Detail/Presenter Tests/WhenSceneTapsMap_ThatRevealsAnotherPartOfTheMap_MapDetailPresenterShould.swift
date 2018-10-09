//
//  WhenSceneTapsMap_ThatRevealsAnotherPartOfTheMap_MapDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 28/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCore
import XCTest

class WhenSceneTapsMap_ThatRevealsAnotherPartOfTheMap_MapDetailPresenterShould: XCTestCase {
    
    func testTellTheMapToFocusOnSpecificPoint() {
        let identifier = Map2.Identifier.random
        let interactor = FakeMapDetailInteractor(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(interactor).build(for: identifier)
        context.simulateSceneDidLoad()
        let randomLocation = MapCoordinate(x: Float.random, y: Float.random)
        context.simulateSceneDidDidTapMap(at: randomLocation)
        let expected = MapCoordinate(x: .random, y: .random)
        interactor.viewModel.resolvePositionalContent(with: expected)
        
        XCTAssertEqual(expected, context.scene.capturedMapPositionToFocus)
    }
    
}
