//
//  BeforeAnnouncementsDetailSceneLoads_AnnouncementsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class BeforeAnnouncementsDetailSceneLoads_AnnouncementsPresenterShould: XCTestCase {

    func testNotBindOntoTheScene() {
        let context = AnnouncementsPresenterTestBuilder().build()
        XCTAssertNil(context.scene.capturedAnnouncementsToBind)
    }

}
