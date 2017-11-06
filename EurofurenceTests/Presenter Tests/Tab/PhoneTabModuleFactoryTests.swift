//
//  PhoneTabModuleFactoryTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class PhoneTabModuleFactoryTests: XCTestCase {
    
    func testReturnsTabBarController() {
        let factory = PhoneTabModuleFactory()
        let vc = factory.makeTabModule([])
        
        XCTAssertTrue(vc is UITabBarController)
    }
    
    func testSetsChildModulesAsChildViewControllers() {
        let childModules = [UIViewController(), UIViewController()]
        let factory = PhoneTabModuleFactory()
        let vc = factory.makeTabModule(childModules)
        let actual: [UIViewController] = (vc as? UITabBarController)?.viewControllers ?? []
        
        XCTAssertEqual(childModules, actual)
    }
    
}
