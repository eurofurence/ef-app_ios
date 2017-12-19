//
//  WhenTheTutorialAppears.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenTheTutorialAppears: XCTestCase {

    private func showTutorial(_ networkReachability: NetworkReachability = ReachableWiFiNetwork(),
                              _ pushPermissionsRequestStateProviding: WitnessedTutorialPushPermissionsRequest = UserNotAcknowledgedPushPermissions()) -> TutorialModuleTestBuilder.Context {
        return TutorialModuleTestBuilder().with(networkReachability).with(pushPermissionsRequestStateProviding).build()
    }
    
    private func showRequestPushPermissionsTutorialPage() -> TutorialModuleTestBuilder.Context {
        return showTutorial(ReachableWiFiNetwork(), UserNotAcknowledgedPushPermissions())
    }
    
    private func showBeginInitialDownloadTutorialPage(_ networkReachability: NetworkReachability = ReachableWiFiNetwork()) -> TutorialModuleTestBuilder.Context {
        let setup = showTutorial(networkReachability, UserNotAcknowledgedPushPermissions())
        setup.tutorial.tutorialPage.simulateTappingSecondaryActionButton()
        return setup
    }
    
    func testItShouldBeToldToShowTheTutorialPage() {
        let setup = showTutorial()
        XCTAssertTrue(setup.tutorial.wasToldToShowTutorialPage)
    }
    
    func testItShouldReturnTheViewControllerFromTheFactory() {
        let setup = showTutorial()
        XCTAssertEqual(setup.tutorialViewController, setup.tutorial)
    }
    
    // MARK: Prepare for initial download page

    

}
