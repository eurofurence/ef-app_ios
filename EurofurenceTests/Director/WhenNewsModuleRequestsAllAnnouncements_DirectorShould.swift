//
//  WhenNewsModuleRequestsAllAnnouncements_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenNewsModuleRequestsAllAnnouncements_DirectorShould: XCTestCase {
    
    func testPushTheAnnouncementsModuleOntoTheNewsNavigationController() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let newsNavigationController = context.navigationController(for: context.newsModule.stubInterface)
        context.newsModule.simulateAllAnnouncementsDisplayRequested()
        
        XCTAssertEqual(context.announcementsModule.stubInterface, newsNavigationController?.topViewController)
    }
    
}
