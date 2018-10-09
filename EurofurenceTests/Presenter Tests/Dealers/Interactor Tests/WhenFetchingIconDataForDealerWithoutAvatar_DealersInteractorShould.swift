//
//  WhenFetchingIconDataForDealerWithoutAvatar_DealersInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCore
import XCTest

class WhenFetchingIconDataForDealerWithoutAvatar_DealersInteractorShould: XCTestCase {
    
    func testSupplyTheStockIconData() {
        let dealer = Dealer2.random
        let group = AlphabetisedDealersGroup(indexingString: .random, dealers: [dealer])
        let index = FakeDealersIndex(alphabetisedDealers: [group])
        let dealersService = FakeDealersService(index: index)
        let defaultIconData = Data.random
        let context = DealerInteractorTestBuilder().with(dealersService).with(defaultIconData).build()
        var viewModel: DealersViewModel?
        context.interactor.makeDealersViewModel { viewModel = $0 }
        let delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
        let dealerViewModel = delegate.capturedDealerViewModel(at: IndexPath(item: 0, section: 0))
        var actual: Data?
        dealerViewModel?.fetchIconPNGData { actual = $0 }
        
        XCTAssertEqual(defaultIconData, actual)
    }
    
}
