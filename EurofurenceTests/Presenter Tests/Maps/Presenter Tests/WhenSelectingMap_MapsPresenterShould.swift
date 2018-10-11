//
//  WhenSelectingMap_MapsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import XCTest

class WhenSelectingMap_MapsPresenterShould: XCTestCase {

    func testTellTheDelegateToShowDetailsForMapWithItsIdentifier() {
        let viewModel = FakeMapsViewModel()
        let interactor = FakeMapsInteractor(viewModel: viewModel)
        let context = MapsPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let mapViewModel = viewModel.maps.randomElement()
        context.simulateSceneDidSelectMap(at: mapViewModel.index)

        XCTAssertEqual(viewModel.identifierForMap(at: mapViewModel.index), context.delegate.capturedMapIdentifierToPresent)
    }

}
