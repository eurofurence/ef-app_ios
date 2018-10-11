//
//  WhenNewsModuleSelectsEvent_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenNewsModuleSelectsEvent_DirectorShould: XCTestCase {
    
    func testPushEventDetailModuleOntoNewsNavigationController() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let newsNavigationController = context.navigationController(for: context.newsModule.stubInterface)
        let event = Event.random
        context.newsModule.simulateDidSelectEvent(event)
        
        XCTAssertEqual(context.eventDetailModule.stubInterface, newsNavigationController?.topViewController)
        XCTAssertEqual(event.identifier, context.eventDetailModule.capturedModel)
    }
    
}
