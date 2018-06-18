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
        let group = DealersGroupViewModel(dealers: [dealerViewModel])
        let viewModel = CapturingDealersViewModel(dealerGroups: [group])
        let interactor = FakeDealersInteractor(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let indexPath = IndexPath(item: 0, section: 0)
        let component = CapturingDealerComponent()
        context.bind(component, toDealerAt: indexPath)
        
        XCTAssertFalse(component.didShowNotPresentOnAllDaysWarning)
    }
    
    func testHideTheWarningIndicatingTheyAreNotPresentOnAllDays() {
        let dealerViewModel = StubDealerViewModel.random
        dealerViewModel.isPresentForAllDays = true
        let group = DealersGroupViewModel(dealers: [dealerViewModel])
        let viewModel = CapturingDealersViewModel(dealerGroups: [group])
        let interactor = FakeDealersInteractor(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let indexPath = IndexPath(item: 0, section: 0)
        let component = CapturingDealerComponent()
        context.bind(component, toDealerAt: indexPath)
        
        XCTAssertTrue(component.didHideNotPresentOnAllDaysWarning)
    }
    
}
