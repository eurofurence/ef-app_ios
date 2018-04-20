//
//  WhenNewsSceneWillReappear_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 10/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenNewsSceneWillReappear_NewsPresenterShould: XCTestCase {
    
    func testNotDetermineAuthStateMultipleTimes() {
        let context = NewsPresenterTestBuilder().build()
        context.simulateNewsSceneWillAppear()
        context.simulateNewsSceneWillAppear()
        
        XCTAssertEqual(1, context.authService.authStateDeterminedCount)
    }
    
}
