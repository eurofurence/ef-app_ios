//
//  WhenDealersIndexProducesNewSearchResults_DealersInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDealersIndexProducesNewSearchResults_DealersInteractorShould: XCTestCase {

    func testConvertIndexedDealersIntoExpectedGroupTitles() {
        let index = FakeDealersIndex()
        let modelDealers = index.alphabetisedDealersSearchResult
        let expected = modelDealers.map { $0.indexingString }
        let dealersService = FakeDealersService(index: index)
        let context = DealerInteractorTestBuilder().with(dealersService).build()
        var searchViewModel: DealersSearchViewModel?
        context.interactor.makeDealersSearchViewModel { searchViewModel = $0 }
        let delegate = CapturingDealersSearchViewModelDelegate()
        searchViewModel?.setSearchResultsDelegate(delegate)
        let actual = delegate.capturedSearchResults.map({ $0.title })

        XCTAssertEqual(expected, actual)
    }

}
