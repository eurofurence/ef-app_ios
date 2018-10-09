//
//  WhenBuildingNewsModule.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenBuildingNewsModule: XCTestCase {
    
    func testTheInteractorDoesNotPrepareViewModel() {
        let newsInteractor = FakeNewsInteractor()
        _ = NewsPresenterTestBuilder().with(newsInteractor).build()
        
        XCTAssertFalse(newsInteractor.didPrepareViewModel)
    }
    
}
