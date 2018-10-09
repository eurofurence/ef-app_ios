//
//  WhenSceneInstigatesPullToRefresh_DealersPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenSceneInstigatesPullToRefresh_DealersPresenterShould: XCTestCase {
    
    func testTellTheViewModelToRefresh() {
        let viewModel = CapturingDealersViewModel()
        let interactor = FakeDealersInteractor(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidPerformRefreshAction()
        
        XCTAssertTrue(viewModel.wasToldToRefresh)
    }
    
}
