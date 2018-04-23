//
//  DefaultNewsInteractorTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class DefaultNewsInteractorTests: XCTestCase {
    
    func testNotBeingLoggedInEmitsViewModelWithLoginPromptUserWidgetViewModel() {
        let loggedOutAuthService = FakeAuthenticationService(authState: .loggedOut)
        let delegate = CapturingNewsInteractorDelegate()
        let interactor = DefaultNewsInteractor(authenticationService: loggedOutAuthService)
        interactor.subscribeViewModelUpdates(delegate)
        let expectedViewModel = UserWidgetComponentViewModel(prompt: .anonymousUserLoginPrompt,
                                                             detailedPrompt: .anonymousUserLoginDescription,
                                                             hasUnreadMessages: false)
        let expected = [AnyHashable(expectedViewModel)]
        
        XCTAssertTrue(delegate.didWitnessViewModelWithComponents(expected))
    }
    
}
