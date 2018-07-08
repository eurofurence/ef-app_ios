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
        return [context.newsModule.stubInterface,
                context.scheduleModule.stubInterface,
                context.dealersModule.stubInterface,
                context.collectThemAllModule.stubInterface,
                context.knowledgeListModule.stubInterface,
                context.mapsModule.stubInterface]
    }
    
    private func rootNavigationTabControllers() -> [UINavigationController] {
        return context.tabModule.capturedTabModules.compactMap({ $0 as? UINavigationController })
    }
    
    func testShowTheModulesInDefaultOrder() {
        let expectedModuleControllers = makeExpectedTabViewControllerRoots()
        let presentedModules = rootNavigationTabControllers().compactMap({ $0.topViewController })
        let expectedTabBarItems: [UITabBarItem] = expectedModuleControllers.map({ $0.tabBarItem })
        let actualTabBarItems: [UITabBarItem] = rootNavigationTabControllers().compactMap({ $0.tabBarItem })
        
        XCTAssertEqual(expectedModuleControllers, presentedModules)
        XCTAssertEqual(expectedTabBarItems, actualTabBarItems)
    }
    
}
