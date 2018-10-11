//
//  WhenSelectingMap_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenSelectingMap_DirectorShould: XCTestCase {

    func testShowTheMapDetailModuleForTheSelectedMapIdentifier() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let mapsNavigationController = context.navigationController(for: context.mapsModule.stubInterface)
        let map = Map.Identifier.random
        context.mapsModule.simulateDidSelectMap(map)

        XCTAssertEqual(context.mapDetailModule.stubInterface, mapsNavigationController?.topViewController)
        XCTAssertEqual(map, context.mapDetailModule.capturedModel)
    }

}
