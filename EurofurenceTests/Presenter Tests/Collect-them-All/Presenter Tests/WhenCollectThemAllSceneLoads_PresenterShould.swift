//
//  WhenCollectThemAllSceneLoads_PresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenCollectThemAllSceneLoads_PresenterShould: XCTestCase {
    
    func testTellTheSceneToLoadTheURLFromTheCollectThemAllService() {
        let context = CollectThemAllPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(context.service.urlRequest, context.scene.capturedURLRequest)
    }
    
}
