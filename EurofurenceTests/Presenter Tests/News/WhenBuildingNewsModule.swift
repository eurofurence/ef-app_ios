//
//  WhenBuildingNewsModule.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBuildingNewsModule: XCTestCase {
    
    func testTheInteractorDoesNotPrepareViewModel() {
        let context = NewsPresenterTestBuilder().build()
        XCTAssertFalse(context.newsInteractor.didPrepareViewModel)
    }
    
}
