//
//  WhenToldToHandleNotification_ThatConcludesWithAnnouncementThatIsInvalid_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenToldToHandleNotification_ThatConcludesWithAnnouncementThatIsInvalid_DirectorShould: XCTestCase {
    
    func testReturnNoDataResultToCompletionHandler() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let payload = [String.random : String.random]
        context.notificationHandling.stub(.invalidatedAnnouncement, for: payload)
        var result: UIBackgroundFetchResult?
        context.director.handleRemoteNotification(payload) { result = $0 }
        
        XCTAssertEqual(UIBackgroundFetchResult.noData, result)
    }
    
}
