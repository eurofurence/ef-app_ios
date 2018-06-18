//
//  WhenBindingDealerComponent_ForDealerNotPresentOnAllDays_DealersPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingDealerComponent_ForDealerNotPresentOnAllDays_DealersPresenterShould: XCTestCase {
    
    func testTellTheSceneToShowTheNotPresentOnAllDaysWarning() {
        var dealerViewModel = StubDealerViewModel.random
        dealerViewModel.isPresentForAllDays = false
        let group = DealersGroupViewModel(dealers: [dealerViewModel])
        let viewModel = CapturingDealersViewModel(dealerGroups: [group])
        let interactor = FakeDealersInteractor(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let indexPath = IndexPath(item: 0, section: 0)
        let component = CapturingDealerComponent()
        context.bind(component, toDealerAt: indexPath)
        
        XCTAssertTrue(component.didShowNotPresentOnAllDaysWarning)
    }
    
}
