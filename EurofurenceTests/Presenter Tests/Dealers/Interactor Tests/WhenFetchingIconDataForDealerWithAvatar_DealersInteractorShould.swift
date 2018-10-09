//
//  WhenFetchingIconDataForDealerWithAvatar_DealersInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCore
import XCTest

class WhenFetchingIconDataForDealerWithAvatar_DealersInteractorShould: XCTestCase {
    
    func testSupplyTheAvatarFromTheDealersService() {
        let dealer = Dealer2.random
        let group = AlphabetisedDealersGroup(indexingString: .random, dealers: [dealer])
        let index = FakeDealersIndex(alphabetisedDealers: [group])
        let dealersService = FakeDealersService(index: index)
        let context = DealerInteractorTestBuilder().with(dealersService).build()
        var viewModel: DealersViewModel?
        context.interactor.makeDealersViewModel { viewModel = $0 }
        let delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
        let dealerViewModel = delegate.capturedDealerViewModel(at: IndexPath(item: 0, section: 0))
        let expected = Data.random
        dealersService.stubIconPNGData(expected, for: dealer.identifier)
        var actual: Data?
        dealerViewModel?.fetchIconPNGData { actual = $0 }
        
        XCTAssertEqual(expected, actual)
    }
    
}
