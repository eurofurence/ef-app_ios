//
//  WhenPreparingViewModel_DealersInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class FakeDealersIndex: DealersIndex {
    
    var alphabetisedDealers = [AlphabetisedDealersGroup].random
    
    func setDelegate(_ delegate: DealersIndexDelegate) {
        delegate.alphabetisedDealersDidChange(to: alphabetisedDealers)
    }
    
}

extension AlphabetisedDealersGroup: RandomValueProviding {
    
    static var random: AlphabetisedDealersGroup {
        return AlphabetisedDealersGroup(indexingString: .random, dealers: .random)
    }
    
}

class WhenPreparingViewModel_DealersInteractorShould: XCTestCase {
    
    func testConvertIndexedDealersIntoExpectedGroupTitles() {
        let dealersService = FakeDealersService()
        let interactor = DefaultDealersInteractor(dealersService: dealersService)
        var viewModel: DealersViewModel?
        interactor.makeDealersViewModel { viewModel = $0 }
        let delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
        let modelDealers = dealersService.lastCreatedDealersIndex?.alphabetisedDealers
        let expected = modelDealers?.map { $0.indexingString }
        let actual = delegate.capturedGroups.map({ $0.title })
        
        XCTAssertEqual(expected, actual)
    }
    
}
