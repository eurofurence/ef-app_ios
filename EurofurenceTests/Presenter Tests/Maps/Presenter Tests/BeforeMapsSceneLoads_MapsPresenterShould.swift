//
//  BeforeMapsSceneLoads_MapsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class BeforeMapsSceneLoads_MapsPresenterShould: XCTestCase {
    
    func testNotPerformAnySceneBindings() {
        let context = MapsPresenterTestBuilder().build()
        XCTAssertNil(context.scene.boundNumberOfMaps)
    }
    
}
