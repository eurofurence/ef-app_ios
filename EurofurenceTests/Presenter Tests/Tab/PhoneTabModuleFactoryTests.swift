//
//  PhoneTabModuleFactoryTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class PhoneTabModuleFactoryTests: XCTestCase {
    
    func testSetsChildModulesAsChildViewControllers() {
        let childModules = [UIViewController(), UIViewController()]
        let factory = PhoneTabModuleFactory()
        let vc = factory.makeTabModule(childModules)
        let actual: [UIViewController] = vc.viewControllers ?? []
        
        XCTAssertEqual(childModules, actual)
    }
    
}
