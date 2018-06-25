//
//  WhenShowingMessagesModuleAlerts_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenShowingMessagesModuleAlerts_DirectorShould: XCTestCase {
    
    func testShowLogoutAlertWithExpectedText() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        context.newsModule.simulatePrivateMessagesDisplayRequested()
        context.messages.delegate?.showLogoutAlert(presentedHandler: { (_) in
            
        })
        
        let presentedAlertController = context.tabModule.stubInterface.capturedPresentedViewController as? UIAlertController
        
        XCTAssertEqual(.loggingOut, presentedAlertController?.title)
        XCTAssertEqual(.loggingOutAlertDetail, presentedAlertController?.message)
    }
    
}
