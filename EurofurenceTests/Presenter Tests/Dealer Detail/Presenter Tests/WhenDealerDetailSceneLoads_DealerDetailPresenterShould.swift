//
//  WhenDealerDetailSceneLoads_DealerDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenDealerDetailSceneLoads_DealerDetailPresenterShould: XCTestCase {

    func testTellTheInteractorToMakeViewModelUsingDealerIdentifier() {
        let identifier: Dealer.Identifier = .random
        let context = DealerDetailPresenterTestBuilder().build(for: identifier)
        context.simulateSceneDidLoad()

        XCTAssertEqual(identifier, context.interactor.capturedIdentifierForProducingViewModel)
    }

    func testTellTheSceneToBindNumberOfComponentsFromTheViewModelOntoTheScene() {
        let viewModel = FakeDealerDetailViewModel(numberOfComponents: .random)
        let interactor = FakeDealerDetailInteractor(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()

        XCTAssertEqual(viewModel.numberOfComponents, context.scene.boundNumberOfComponents)
    }

}
