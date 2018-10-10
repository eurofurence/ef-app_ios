//
//  WhenUserSelectsMessage_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenUserSelectsMessage_DirectorShould: XCTestCase {
    
    var context: ApplicationDirectorTestBuilder.Context!
    var message: Message!
    
    override func setUp() {
        super.setUp()
        
        message = .random
        context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        context.newsModule.simulatePrivateMessagesDisplayRequested()
        context.messages.simulateMessagePresentationRequested(message)
    }
    
    func testBuildMessageDetailModuleUsingMessage() {
        XCTAssertEqual(message, context.messageDetailModule.capturedMessage)
    }
    
    func testPushMessageDetailModuleOntoMessagesNavigationController() {
        let navigationController = context.messages.stubInterface.navigationController
        XCTAssertEqual(context.messageDetailModule.stubInterface, navigationController?.topViewController)
    }
    
}
