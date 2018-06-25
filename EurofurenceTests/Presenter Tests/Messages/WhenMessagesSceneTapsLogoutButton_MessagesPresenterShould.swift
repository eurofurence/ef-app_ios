//
//  WhenMessagesSceneTapsLogoutButton_MessagesPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenMessagesSceneTapsLogoutButton_MessagesPresenterShould: XCTestCase {
    
    func testTellTheDelegateToShowTheLoggingOutAlert() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
        context.scene.delegate?.messagesSceneDidTapLogoutButton()
        
        XCTAssertTrue(context.delegate.wasToldToShowLoggingOutAlert)
    }
    
    func testTellTheAuthenticationServiceToLogoutWhenTheLoginAlertIsPresented() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
        context.scene.delegate?.messagesSceneDidTapLogoutButton()
        context.delegate.capturedAlertPresentedBlock?({})
        
        XCTAssertTrue(context.authenticationService.wasToldToLogout)
    }
    
    func testInvokeTheAlertDismissalBlockWhenAuthenticationServiceFinishes() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
        context.scene.delegate?.messagesSceneDidTapLogoutButton()
        var didInvokeDismissalHandlerForPresentedLogoutAlert = false
        context.delegate.capturedAlertPresentedBlock?({ didInvokeDismissalHandlerForPresentedLogoutAlert = true })
        context.authenticationService.capturedLogoutHandler?(.success)
        
        XCTAssertTrue(didInvokeDismissalHandlerForPresentedLogoutAlert)
    }
    
    func testTellTheDelegateToDismissTheMessagesModuleWhenLogoutSucceeds() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
        context.scene.delegate?.messagesSceneDidTapLogoutButton()
        context.delegate.capturedAlertPresentedBlock?({})
        context.authenticationService.capturedLogoutHandler?(.success)
        
        XCTAssertTrue(context.delegate.dismissed)
    }
    
}
