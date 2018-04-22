//
//  WhenShowingTabModule_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import XCTest

class WhenShowingTabModule_DirectorShould: XCTestCase {
    
    var context: ApplicationDirectorTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
    }
    
    private func makeExpectedTabViewControllerRoots() -> [UIViewController] {
        return [context.newsModule.stubInterface, context.knowledgeListModule.stubInterface]
    }
    
    private func rootNavigationTabControllers() -> [UINavigationController] {
        return context.tabModule.capturedTabModules.flatMap({ $0 as? UINavigationController })
    }
    
    func testShowTheModulesInDefaultOrder() {
        context.navigateToTabController()
        let expected = makeExpectedTabViewControllerRoots()
        let actual = rootNavigationTabControllers().flatMap({ $0.topViewController })
        
        XCTAssertEqual(expected, actual)
    }
    
    func testUseTheTabBarItemsFromEachModule() {
        context.navigateToTabController()
        let expected: [UITabBarItem] = makeExpectedTabViewControllerRoots().map({ $0.tabBarItem })
        let actual: [UITabBarItem] = rootNavigationTabControllers().flatMap({ $0.tabBarItem })
        
        XCTAssertEqual(expected, actual)
    }
    
}
