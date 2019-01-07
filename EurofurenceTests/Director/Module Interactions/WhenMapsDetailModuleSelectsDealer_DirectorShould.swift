//
//  WhenMapsDetailModuleSelectsDealer_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 29/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenMapsDetailModuleSelectsDealer_DirectorShould: XCTestCase {

    func testPresentTheDealerDetailModuleOntoTheMapsNavigationController() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let map = Map.Identifier.random
        context.mapsModule.simulateDidSelectMap(map)
        let mapsNavigationController = context.navigationController(for: context.mapsModule.stubInterface)
        let dealer = DealerIdentifier.random
        context.mapDetailModule.simulateDidSelectDealer(dealer)

        XCTAssertEqual(context.dealerDetailModule.stubInterface, mapsNavigationController?.topViewController)
        XCTAssertEqual(dealer, context.dealerDetailModule.capturedModel)
    }

}
