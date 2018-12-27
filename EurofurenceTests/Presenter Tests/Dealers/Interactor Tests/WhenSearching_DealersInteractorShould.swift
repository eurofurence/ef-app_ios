//
//  WhenSearching_DealersInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenSearching_DealersInteractorShould: XCTestCase {

    func testChangeSearchTermToUsedInput() {
        let index = FakeDealersIndex()
        let dealersService = FakeDealersService(index: index)
        let context = DealerInteractorTestBuilder().with(dealersService).build()
        var searchViewModel: DealersSearchViewModel?
        context.interactor.makeDealersSearchViewModel { searchViewModel = $0 }
        let searchTerm = String.random
        searchViewModel?.updateSearchResults(with: searchTerm)

        XCTAssertEqual(searchTerm, index.capturedSearchTerm)
    }

}
