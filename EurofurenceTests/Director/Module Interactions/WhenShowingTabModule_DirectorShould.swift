//
//  WhenShowingTabModule_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class FakeModuleOrderingPolicy: ModuleOrderingPolicy {
    
    private(set) var producedModules = [UIViewController]()
    func order(modules: [UIViewController]) -> [UIViewController] {
        producedModules = modules.randomized()
        return producedModules
    }
    
}

extension Array {
    
    func randomized() -> [Element] {
        var copy = self
        var output = [Element]()
        while copy.isEmpty == false {
            let next = copy.randomElement()
            output.append(copy.remove(at: next.index))
        }
        
        return output
    }
    
}

class WhenShowingTabModule_DirectorShould: XCTestCase {
    
    func testShowTheModulesInOrderDesignatedByOrderingPolicy() {
        let context = ApplicationDirectorTestBuilder().build()
        let moduleOrderingPolicy = context.moduleOrderingPolicy
        context.navigateToTabController()
        
        let rootNavigationTabControllers = context.tabModule.capturedTabModules.compactMap({ $0 as? UINavigationController })
        let expectedModuleControllers = moduleOrderingPolicy.producedModules
        
        let expectedTabBarItems: [UITabBarItem] = expectedModuleControllers.map({ $0.tabBarItem })
        let actualTabBarItems: [UITabBarItem] = rootNavigationTabControllers.compactMap({ $0.tabBarItem })
        
        XCTAssertEqual(expectedModuleControllers, rootNavigationTabControllers)
        XCTAssertEqual(expectedTabBarItems, actualTabBarItems)
    }
    
}
