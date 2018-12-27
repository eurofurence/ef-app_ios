//
//  WhenToldToHandleNotification_ThatConcludesWithAnnouncement_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenToldToHandleNotification_ThatConcludesWithAnnouncement_DirectorShould: XCTestCase {

    func testReturnNewDataResultToCompletionHandler() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let payload = [String.random: String.random]
        let announcement = Announcement.Identifier.random
        context.notificationHandling.stub(.announcement(announcement), for: payload)
        var result: UIBackgroundFetchResult?
        context.director.handleRemoteNotification(payload) { result = $0 }

        XCTAssertEqual(UIBackgroundFetchResult.newData, result)
    }

}
