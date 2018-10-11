//
//  WhenAnnouncementDetailSceneDidLoad_AnnouncementDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenAnnouncementDetailSceneDidLoad_AnnouncementDetailPresenterShould: XCTestCase {

    func testApplyTheTitleOfTheAnnouncementFromTheViewModelOntoTheScene() {
        let context = AnnouncementDetailPresenterTestBuilder().build()
        context.simulateAnnouncementDetailSceneDidLoad()

        XCTAssertEqual(context.announcementViewModel.heading, context.scene.capturedAnnouncementHeading)
    }

    func testApplyTheContentsOfTheAnnouncementFromTheViewModelOntoTheScene() {
        let context = AnnouncementDetailPresenterTestBuilder().build()
        context.simulateAnnouncementDetailSceneDidLoad()

        XCTAssertEqual(context.announcementViewModel.contents, context.scene.capturedAnnouncementContents)
    }

}
