//
//  WhenSceneSelectsSearchResult_DealersPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSceneSelectsSearchResult_DealersPresenterShould: XCTestCase {

    func testTellTheModuleDelegateTheDealerIdentifierForTheSearchResultIndexPathWasSelected() {
        let searchViewModel = CapturingDealersSearchViewModel()
        let identifier = DealerIdentifier.random
        let indexPath = IndexPath.random
        searchViewModel.stub(identifier, forDealerAt: indexPath)
        let interactor = FakeDealersInteractor(searchViewModel: searchViewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidSelectSearchResult(at: indexPath)

        XCTAssertEqual(identifier, context.delegate.capturedSelectedDealerIdentifier)
    }

}
