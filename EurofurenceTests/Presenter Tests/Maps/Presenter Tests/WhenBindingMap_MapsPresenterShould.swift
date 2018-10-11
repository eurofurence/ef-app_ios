//
//  WhenBindingMap_MapsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenBindingMap_MapsPresenterShould: XCTestCase {

    func testBindTheNameOfTheMapOntoTheComponent() {
        let viewModel = FakeMapsViewModel()
        let interactor = FakeMapsInteractor(viewModel: viewModel)
        let context = MapsPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let mapViewModel = viewModel.maps.randomElement()
        let boundComponent = context.bindMap(at: mapViewModel.index)

        XCTAssertEqual(mapViewModel.element.mapName, boundComponent.boundMapName)
    }

    func testBindTheMapPreviewOntoTheComponent() {
        let viewModel = FakeMapsViewModel()
        let interactor = FakeMapsInteractor(viewModel: viewModel)
        let context = MapsPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let mapViewModel = viewModel.maps.randomElement()
        let boundComponent = context.bindMap(at: mapViewModel.index)

        XCTAssertEqual(mapViewModel.element.mapPreviewImagePNGData, boundComponent.boundMapPreviewData)
    }

}
