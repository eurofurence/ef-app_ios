//
//  PlatformTabModuleFactoryTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class PlatformTabModuleFactoryTests: XCTestCase {

    func testSetsChildModulesAsChildViewControllers() {
        let childModules = [UIViewController(), UIViewController()]
        let factory = PlatformTabModuleFactory()
        let vc = factory.makeTabModule(childModules)
        let actual: [UIViewController] = vc.viewControllers ?? []

        XCTAssertEqual(childModules, actual)
    }

}
