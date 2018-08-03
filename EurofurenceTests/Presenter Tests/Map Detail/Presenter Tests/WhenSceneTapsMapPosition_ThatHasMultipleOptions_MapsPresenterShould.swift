//
//  WhenSceneTapsMapPosition_ThatHasMultipleOptions_MapsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 03/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenSceneTapsMapPosition_ThatHasMultipleOptions_MapsPresenterShould: XCTestCase {
    
    func testTellTheSceneToShowTheOptions() {
        let identifier = Map2.Identifier.random
        let interactor = FakeMapDetailInteractor(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(interactor).build(for: identifier)
        context.simulateSceneDidLoad()
        let x = Float.random
        let y = Float.random
        let randomLocation = MapCoordinate(x: x, y: y)
        context.simulateSceneDidDidTapMap(at: randomLocation)
        let contentOptions = StubMapContentOptionsViewModel.random
        interactor.viewModel.resolvePositionalContent(with: contentOptions)
        
        XCTAssertEqual(contentOptions.optionsHeading, context.scene.capturedOptionsHeading)
        XCTAssertEqual(contentOptions.options, context.scene.capturedOptionsToShow)
        XCTAssertEqual(x, context.scene.capturedOptionsPresentationX.or(.random), accuracy: .ulpOfOne)
        XCTAssertEqual(y, context.scene.capturedOptionsPresentationY.or(.random), accuracy: .ulpOfOne)
    }
    
}
