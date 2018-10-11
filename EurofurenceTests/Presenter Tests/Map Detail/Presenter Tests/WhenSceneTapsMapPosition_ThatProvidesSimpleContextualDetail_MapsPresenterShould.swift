//
//  WhenSceneTapsMapPosition_ThatProvidesSimpleContextualDetail_MapsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 28/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenSceneTapsMapPosition_ThatProvidesSimpleContextualDetail_MapsPresenterShould: XCTestCase {

    func testTellTheSceneToShowTheDetailAtTheSpecifiedLocation() {
        let identifier = Map.Identifier.random
        let interactor = FakeMapDetailInteractor(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(interactor).build(for: identifier)
        context.simulateSceneDidLoad()
        let randomLocation = MapCoordinate(x: Float.random, y: Float.random)
        context.simulateSceneDidDidTapMap(at: randomLocation)
        let expected = MapInformationContextualContent(coordinate: randomLocation, content: .random)
        interactor.viewModel.resolvePositionalContent(with: expected)

        XCTAssertEqual(expected, context.scene.presentedContextualContext)
    }

}
