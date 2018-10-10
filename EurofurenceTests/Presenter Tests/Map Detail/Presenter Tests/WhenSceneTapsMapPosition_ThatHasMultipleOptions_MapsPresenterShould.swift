//
//  WhenSceneTapsMapPosition_ThatHasMultipleOptions_MapsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 03/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenSceneTapsMapPosition_ThatHasMultipleOptions_MapsPresenterShould: XCTestCase {
    
    func testTellTheSceneToShowTheOptions() {
        let identifier = Map.Identifier.random
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
    
    func testTellTheViewModelWhichOptionIsSelected() {
        let identifier = Map.Identifier.random
        let interactor = FakeMapDetailInteractor(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(interactor).build(for: identifier)
        context.simulateSceneDidLoad()
        let randomLocation = MapCoordinate(x: .random, y: .random)
        context.simulateSceneDidDidTapMap(at: randomLocation)
        let contentOptions = StubMapContentOptionsViewModel.random
        interactor.viewModel.resolvePositionalContent(with: contentOptions)
        let selectedOptionIndex = contentOptions.options.randomElement().index
        context.simulateSceneTappedMapOption(at: selectedOptionIndex)
        
        XCTAssertEqual(selectedOptionIndex, contentOptions.selectedOptionIndex)
    }
    
}
