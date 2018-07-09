//
//  RestorationIdentifierOrderingPolicyTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class RestorationIdentifierOrderingPolicyTests: XCTestCase {
    
    func testBeforeSavingOrderReturnsModulesInExistingOrder() {
        let policy = RestorationIdentifierOrderingPolicy()
        let modules = [UIViewController(), UIViewController(), UIViewController()]
        let ordered = policy.order(modules: modules)
        
        XCTAssertEqual(modules, ordered)
    }
    
}
