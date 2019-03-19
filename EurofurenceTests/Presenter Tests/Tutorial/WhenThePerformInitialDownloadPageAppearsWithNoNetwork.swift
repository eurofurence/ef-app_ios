//
//  WhenThePerformInitialDownloadPageAppearsWithNoNetwork.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenThePerformInitialDownloadPageAppearsWithNoNetwork: XCTestCase {

    var context: TutorialModuleTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = TutorialModuleTestBuilder()
            .with(NoNetwork())
            .with(UserAcknowledgedPushPermissions())
            .build()
    }
    
    func testAttemptingDownloadShowsNoNetworkAlert() {
        context.page.simulateTappingPrimaryActionButton()
        
        let action = context.alertRouter.presentedActions.first
        
        XCTAssertEqual(context.alertRouter.presentedAlertTitle, .noNetworkAlertTitle)
        XCTAssertEqual(context.alertRouter.presentedAlertMessage, .noNetworkAlertMessage)
        XCTAssertEqual(1, context.alertRouter.presentedActions.count)
        XCTAssertEqual(action?.title, .ok)
    }

}
