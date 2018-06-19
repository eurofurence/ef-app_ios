//
//  WhenResolvingDealerAvailability_DealersInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenResolvingDealerAvailability_DealersInteractorShould: XCTestCase {
    
    func testIndicateDealerIsPresentForAllDaysWhenAttendingOnAllDays() {
        var dealer = Dealer2.random
        dealer.isAttendingOnThursday = true
        dealer.isAttendingOnFriday = true
        dealer.isAttendingOnSaturday = true
        let group = AlphabetisedDealersGroup(indexingString: .random, dealers: [dealer])
        let index = FakeDealersIndex(alphabetisedDealers: [group])
        let dealersService = FakeDealersService(index: index)
        let interactor = DefaultDealersInteractor(dealersService: dealersService)
        var viewModel: DealersViewModel?
        interactor.makeDealersViewModel { viewModel = $0 }
        let delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
        let dealerViewModel = delegate.capturedDealerViewModel(at: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(true, dealerViewModel?.isPresentForAllDays)
    }
    
}
