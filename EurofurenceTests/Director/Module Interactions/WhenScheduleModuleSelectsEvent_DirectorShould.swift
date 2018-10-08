//
//  WhenScheduleModuleSelectsEvent_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenScheduleModuleSelectsEvent_DirectorShould: XCTestCase {
    
    func testPushEventDetailModuleOntoScheduleNavigationController() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let scheduleNavigationController = context.navigationController(for: context.scheduleModule.stubInterface)
        let event = Event2.random
        context.scheduleModule.simulateDidSelectEvent(event.identifier)
        
        XCTAssertEqual(context.eventDetailModule.stubInterface, scheduleNavigationController?.topViewController)
        XCTAssertEqual(event.identifier, context.eventDetailModule.capturedModel)
    }
    
}
