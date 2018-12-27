//
//  WhenBindingDealerComponent_ForDealerNotPresentOnAllDays_DealersPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingDealerComponent_ForDealerNotPresentOnAllDays_DealersPresenterShould: XCTestCase {

    func testTellTheSceneToShowTheNotPresentOnAllDaysWarning() {
        let dealerViewModel = StubDealerViewModel.random
        dealerViewModel.isPresentForAllDays = false
        let interactor = FakeDealersInteractor(dealerViewModel: dealerViewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let component = context.makeAndBindDealer(at: IndexPath(item: 0, section: 0))

        XCTAssertTrue(component.didShowNotPresentOnAllDaysWarning)
    }

    func testNotTellTheSceneToHideTheWarningIndicatingTheyAreNotPresentOnAllDays() {
        let dealerViewModel = StubDealerViewModel.random
        dealerViewModel.isPresentForAllDays = false
        let interactor = FakeDealersInteractor(dealerViewModel: dealerViewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let component = context.makeAndBindDealer(at: IndexPath(item: 0, section: 0))

        XCTAssertFalse(component.didHideNotPresentOnAllDaysWarning)
    }

}
