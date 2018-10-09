//
//  WhenToldToRefresh_ScheduleViewModelShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenToldToRefresh_ScheduleViewModelShould: XCTestCase {
    
    func testTellTheRefreshServiceToRefresh() {
        let context = ScheduleInteractorTestBuilder().build()
        let viewModel = context.makeViewModel()
        viewModel?.refresh()
        
        XCTAssertTrue(context.refreshService.toldToRefresh)
    }
    
}
