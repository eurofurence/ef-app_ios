//
//  WhenApplicationRefreshStateChanges_ScheduleInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenApplicationRefreshStateChanges_ScheduleInteractorShould: XCTestCase {
    
    func testTellTheViewModelDelegateWhenRefreshStarts() {
        let context = ScheduleInteractorTestBuilder().build()
        let viewModel = context.makeViewModel()
        viewModel?.refresh()
        let delegate = CapturingScheduleViewModelDelegate()
        viewModel?.setDelegate(delegate)
        context.refreshService.simulateRefreshBegan()
        
        XCTAssertTrue(delegate.viewModelDidBeginRefreshing)
    }
    
    func testTellTheViewModelDelegateWhenRefreshFinishes() {
        let context = ScheduleInteractorTestBuilder().build()
        let viewModel = context.makeViewModel()
        viewModel?.refresh()
        let delegate = CapturingScheduleViewModelDelegate()
        viewModel?.setDelegate(delegate)
        context.refreshService.simulateRefreshBegan()
        context.refreshService.simulateRefreshFinished()
        
        XCTAssertTrue(delegate.viewModelDidFinishRefreshing)
    }
    
}
