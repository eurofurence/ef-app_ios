//
//  WhenToldToRefresh_DealersViewModelShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenToldToRefresh_DealersViewModelShould: XCTestCase {

    func testTellTheRefreshServiceToRefresh() {
        let context = DealerInteractorTestBuilder().build()
        let viewModel = context.prepareViewModel()
        viewModel?.refresh()

        XCTAssertTrue(context.refreshService.toldToRefresh)
    }

}
