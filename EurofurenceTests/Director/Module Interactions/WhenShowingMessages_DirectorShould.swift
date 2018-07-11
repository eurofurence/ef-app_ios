//
//  WhenShowingMessages_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import XCTest

class WhenShowingMessages_DirectorShould: XCTestCase {
    
    var context: ApplicationDirectorTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        context.newsModule.simulatePrivateMessagesDisplayRequested()
    }
    
    func testPushTheMessagesModuleOntoTheNewsNavigationController() {
        let newsNavigationController = context.navigationController(for: context.newsModule.stubInterface)
        
        XCTAssertEqual(context.messages.stubInterface, newsNavigationController?.pushedViewControllers.last)
    }
    
    func testPerformDismissalOnTabModuleWhenDismissingMessages() {
        context.messages.simulateDismissalRequested()
        XCTAssertTrue(context.tabModule.stubInterface.didDismissViewController)
    }
    
    func testPopToTheNewsModuleWhenDismissingMessages() {
        context.messages.simulateDismissalRequested()
        let newsNavigationController = context.navigationController(for: context.newsModule.stubInterface)
        
        XCTAssertEqual(context.newsModule.stubInterface, newsNavigationController?.viewControllerPoppedTo)
    }
    
    func testShowTheLoginModuleWhenRequestingUserResolution() {
        context.messages.simulateResolutionForUser( { _ in })
        let navController = context.tabModule.stubInterface.capturedPresentedViewController as? UINavigationController
        
        XCTAssertEqual(navController?.topViewController, context.loginModule.stubInterface)
        XCTAssertEqual(navController?.modalPresentationStyle, .formSheet)
    }
    
    func testUseFormSheetPresentationWhenRequestingUserResolution() {
        context.messages.simulateResolutionForUser({ _ in })
        
        XCTAssertEqual(context.loginModule.stubInterface.modalPresentationStyle, .formSheet)
    }
    
}
