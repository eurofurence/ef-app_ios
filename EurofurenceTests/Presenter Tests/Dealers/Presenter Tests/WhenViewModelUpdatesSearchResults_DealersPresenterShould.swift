//
//  WhenViewModelUpdatesSearchResults_DealersPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenViewModelUpdatesSearchResults_DealersPresenterShould: XCTestCase {

    func testBindTheCountOfDealersPerGroupFromTheViewModelOntoTheScene() {
        let dealerGroups = [DealersGroupViewModel].random
        let searchViewModel = CapturingDealersSearchViewModel(dealerGroups: dealerGroups)
        let interactor = FakeDealersInteractor(searchViewModel: searchViewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let expected = dealerGroups.map { $0.dealers.count }

        XCTAssertEqual(expected, context.scene.capturedDealersPerSectionToBindToSearchResults)
    }

    func testBindTheSectionIndexTitlesFromTheViewModelOntoTheScene() {
        let searchViewModel = CapturingDealersSearchViewModel()
        let interactor = FakeDealersInteractor(searchViewModel: searchViewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()

        XCTAssertEqual(searchViewModel.sectionIndexTitles, context.scene.capturedSectionIndexTitlesToBindToSearchResults)
    }

}
