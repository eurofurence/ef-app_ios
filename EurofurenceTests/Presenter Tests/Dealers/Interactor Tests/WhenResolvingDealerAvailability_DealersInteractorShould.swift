//
//  WhenResolvingDealerAvailability_DealersInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenResolvingDealerAvailability_DealersInteractorShould: XCTestCase {

    func testIndicateDealerIsPresentForAllDaysWhenAttendingOnAllDays() {
        let dealer = FakeDealer.random
        dealer.isAttendingOnThursday = true
        dealer.isAttendingOnFriday = true
        dealer.isAttendingOnSaturday = true
        let group = AlphabetisedDealersGroup(indexingString: .random, dealers: [dealer])
        let index = FakeDealersIndex(alphabetisedDealers: [group])
        let dealersService = FakeDealersService(index: index)
        let context = DealerInteractorTestBuilder().with(dealersService).build()
        var viewModel: DealersViewModel?
        context.interactor.makeDealersViewModel { viewModel = $0 }
        let delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
        let dealerViewModel = delegate.capturedDealerViewModel(at: IndexPath(item: 0, section: 0))

        XCTAssertEqual(true, dealerViewModel?.isPresentForAllDays)
    }

    func testIndicateDealerIsNotPresentForAllDaysWhenNotAttendingOnThursday() {
        let dealer = FakeDealer.random
        dealer.isAttendingOnThursday = false
        dealer.isAttendingOnFriday = true
        dealer.isAttendingOnSaturday = true
        let group = AlphabetisedDealersGroup(indexingString: .random, dealers: [dealer])
        let index = FakeDealersIndex(alphabetisedDealers: [group])
        let dealersService = FakeDealersService(index: index)
        let context = DealerInteractorTestBuilder().with(dealersService).build()
        var viewModel: DealersViewModel?
        context.interactor.makeDealersViewModel { viewModel = $0 }
        let delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
        let dealerViewModel = delegate.capturedDealerViewModel(at: IndexPath(item: 0, section: 0))

        XCTAssertEqual(false, dealerViewModel?.isPresentForAllDays)
    }

    func testIndicateDealerIsNotPresentForAllDaysWhenNotAttendingOnFriday() {
        let dealer = FakeDealer.random
        dealer.isAttendingOnThursday = true
        dealer.isAttendingOnFriday = false
        dealer.isAttendingOnSaturday = true
        let group = AlphabetisedDealersGroup(indexingString: .random, dealers: [dealer])
        let index = FakeDealersIndex(alphabetisedDealers: [group])
        let dealersService = FakeDealersService(index: index)
        let context = DealerInteractorTestBuilder().with(dealersService).build()
        var viewModel: DealersViewModel?
        context.interactor.makeDealersViewModel { viewModel = $0 }
        let delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
        let dealerViewModel = delegate.capturedDealerViewModel(at: IndexPath(item: 0, section: 0))

        XCTAssertEqual(false, dealerViewModel?.isPresentForAllDays)
    }

    func testIndicateDealerIsNotPresentForAllDaysWhenNotAttendingOnSaturday() {
        let dealer = FakeDealer.random
        dealer.isAttendingOnThursday = true
        dealer.isAttendingOnFriday = true
        dealer.isAttendingOnSaturday = false
        let group = AlphabetisedDealersGroup(indexingString: .random, dealers: [dealer])
        let index = FakeDealersIndex(alphabetisedDealers: [group])
        let dealersService = FakeDealersService(index: index)
        let context = DealerInteractorTestBuilder().with(dealersService).build()
        var viewModel: DealersViewModel?
        context.interactor.makeDealersViewModel { viewModel = $0 }
        let delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
        let dealerViewModel = delegate.capturedDealerViewModel(at: IndexPath(item: 0, section: 0))

        XCTAssertEqual(false, dealerViewModel?.isPresentForAllDays)
    }

}
