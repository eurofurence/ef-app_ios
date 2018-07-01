//
//  WhenApplicationRefreshStateChanges_DealersViewModelShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenApplicationRefreshStateChanges_DealersViewModelShould: XCTestCase {
    
    func testTellTheDelegateRefreshDidBegin() {
        let context = DealerInteractorTestBuilder().build()
        let viewModel = context.prepareViewModel()
        let delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
        context.refreshService.simulateRefreshBegan()
        
        XCTAssertTrue(delegate.toldRefreshDidBegin)
    }
    
    func testTellTheDelegateRefreshDidFinish() {
        let context = DealerInteractorTestBuilder().build()
        let viewModel = context.prepareViewModel()
        let delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
        context.refreshService.simulateRefreshFinished()
        
        XCTAssertTrue(delegate.toldRefreshDidFinish)
    }
    
}
