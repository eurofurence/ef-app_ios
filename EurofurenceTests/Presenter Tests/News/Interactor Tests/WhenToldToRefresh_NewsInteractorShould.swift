//
//  WhenToldToRefresh_NewsInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 29/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenToldToRefresh_NewsInteractorShould: XCTestCase {

    func testTellRefreshServiceToRefresh() {
        let context = DefaultNewsInteractorTestBuilder().build()
        context.interactor.refresh()

        XCTAssertTrue(context.refreshService.toldToRefresh)
    }

}
