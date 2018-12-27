//
//  RestorationIdentifierOrderingPolicyTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class RestorationIdentifierOrderingPolicyTests: XCTestCase {

    func testBeforeSavingOrderReturnsModulesInExistingOrder() {
        let policy = RestorationIdentifierOrderingPolicy()
        let modules = [UIViewController(), UIViewController(), UIViewController()]
        let ordered = policy.order(modules: modules)

        XCTAssertEqual(modules, ordered)
    }

    func testMaintainOrderBetweenReloads() {
        var policy = RestorationIdentifierOrderingPolicy()
        let first = UIViewController()
        first.restorationIdentifier = .random
        let second = UIViewController()
        second.restorationIdentifier = .random
        let third = UIViewController()
        third.restorationIdentifier = .random
        let modules = [second, first, third]
        let randomOrder = modules.randomized()
        policy.saveOrder(randomOrder)
        policy = RestorationIdentifierOrderingPolicy()
        let ordered = policy.order(modules: modules)

        XCTAssertEqual(randomOrder, ordered)
    }

}
