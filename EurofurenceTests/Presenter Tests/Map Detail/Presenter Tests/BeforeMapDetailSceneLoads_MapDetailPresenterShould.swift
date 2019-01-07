//
//  BeforeMapDetailSceneLoads_MapDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class BeforeMapDetailSceneLoads_MapDetailPresenterShould: XCTestCase {

    func testNotBindAnySceneComponents() {
        let identifier = MapIdentifier.random
        let interactor = FakeMapDetailInteractor(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(interactor).build(for: identifier)

        XCTAssertNil(context.scene.capturedTitle)
    }

}
