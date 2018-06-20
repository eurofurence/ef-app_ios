//
//  WhenDealersIndexProducesNewSearchResults_DealersInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingDealersSearchViewModelDelegate: DealersSearchViewModelDelegate {
    
    private(set) var capturedSearchResults = [DealersGroupViewModel]()
    private(set) var capturedIndexTitles = [String]()
    func dealerSearchResultsDidChange(_ groups: [DealersGroupViewModel], indexTitles: [String]) {
        capturedSearchResults = groups
        capturedIndexTitles = indexTitles
    }
    
}

class WhenDealersIndexProducesNewSearchResults_DealersInteractorShould: XCTestCase {
    
    func testConvertIndexedDealersIntoExpectedGroupTitles() {
        let index = FakeDealersIndex()
        let modelDealers = index.alphabetisedDealersSearchResult
        let expected = modelDealers.map { $0.indexingString }
        let dealersService = FakeDealersService(index: index)
        let interactor = DefaultDealersInteractor(dealersService: dealersService)
        var searchViewModel: DealersSearchViewModel?
        interactor.makeDealersSearchViewModel { searchViewModel = $0 }
        let delegate = CapturingDealersSearchViewModelDelegate()
        searchViewModel?.setSearchResultsDelegate(delegate)
        let actual = delegate.capturedSearchResults.map({ $0.title })
        
        XCTAssertEqual(expected, actual)
    }
    
//    func testConvertIndexedDealersIntoExpectedGroupTitles() {
//        let modelDealers = dealersService.index.alphabetisedDealers
//        let expected = modelDealers.map { $0.indexingString }
//        let actual = delegate.capturedGroups.map({ $0.title })
//
//        XCTAssertEqual(expected, actual)
//    }
//
//    func testProduceIndexTitlesUsingGroupedIndicies() {
//        let modelDealers = dealersService.index.alphabetisedDealers
//        let expected = modelDealers.map { $0.indexingString }
//        let actual = delegate.capturedIndexTitles
//
//        XCTAssertEqual(expected, actual)
//    }
//
//    func testBindPreferredDealerNameOntoDealerViewModelTitle() {
//        let context = fetchRandomDealerAndAssociatedViewModel()
//        XCTAssertEqual(context.dealer.preferredName, context.viewModel?.title)
//    }
//
//    func testBindAlternateDealerNameOntoDealerViewModelSubtitle() {
//        let context = fetchRandomDealerAndAssociatedViewModel()
//        XCTAssertEqual(context.dealer.alternateName, context.viewModel?.subtitle)
//    }
    
}
