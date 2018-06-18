//
//  WhenBindingDealerComponent_ForDealerPresentOnAllDays_DealersPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingDealerComponent_ForDealerPresentOnAllDays_DealersPresenterShould: XCTestCase {
    
    func testNotShowTheWarningIndicatingTheyAreNotPresentOnAllDays() {
        let dealerViewModel = StubDealerViewModel.random
        dealerViewModel.isPresentForAllDays = true
        let interactor = FakeDealersInteractor(dealerViewModel: dealerViewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let component = context.makeAndBindDealer(at: IndexPath(item: 0, section: 0))
        
        XCTAssertFalse(component.didShowNotPresentOnAllDaysWarning)
    }
    
    func testHideTheWarningIndicatingTheyAreNotPresentOnAllDays() {
        let dealerViewModel = StubDealerViewModel.random
        dealerViewModel.isPresentForAllDays = true
        let interactor = FakeDealersInteractor(dealerViewModel: dealerViewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let component = context.makeAndBindDealer(at: IndexPath(item: 0, section: 0))
        
        XCTAssertTrue(component.didHideNotPresentOnAllDaysWarning)
    }
    
}
