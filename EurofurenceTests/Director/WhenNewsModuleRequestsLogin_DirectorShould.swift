//
//  WhenNewsModuleRequestsLogin_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import XCTest

// TODO: Drop use case, consolidate into only requesting presentation of messages
class WhenNewsModuleRequestsLogin_DirectorShould: XCTestCase {
    
    func testShowTheMessagesModule() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let newsNavigationController = context.navigationController(for: context.newsModule.stubInterface)
        context.newsModule.simulateLoginRequested()
        
        XCTAssertEqual(context.messages.stubInterface, newsNavigationController?.pushedViewControllers.last)
    }
    
}
