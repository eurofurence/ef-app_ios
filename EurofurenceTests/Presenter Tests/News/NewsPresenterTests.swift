//
//  NewsPresenterTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingAuthService: AuthService {
    
    func add(observer: AuthStateObserver) {
        
    }
    
    private(set) var authStateDeterminedCount = 0
    func determineAuthState(completionHandler: @escaping (AuthState) -> Void) {
        authStateDeterminedCount += 1
    }
    
}

class NewsPresenterTests: XCTestCase {
    
    func testTheAuthServiceIsNotToldToDetermineAuthStateUntilViewWillAppear() {
        let sceneFactory = StubNewsSceneFactory()
        let authenticationService = CapturingAuthenticationService()
        let delegate = CapturingNewsModuleDelegate()
        _ = NewsModuleBuilder()
            .with(sceneFactory)
            .with(authenticationService)
            .with(StubPrivateMessagesService())
            .with(CapturingWelcomePromptStringFactory())
            .build()
            .makeNewsModule(delegate)
        
        XCTAssertEqual(0, authenticationService.authStateDeterminedCount)
    }
    
    func testTheAuthServiceIsNotDeterminedWhenSceneWillReappearAgain() {
        let sceneFactory = StubNewsSceneFactory()
        let authenticationService = CapturingAuthenticationService()
        let delegate = CapturingNewsModuleDelegate()
        _ = NewsModuleBuilder()
            .with(sceneFactory)
            .with(authenticationService)
            .with(StubPrivateMessagesService())
            .with(CapturingWelcomePromptStringFactory())
            .build()
            .makeNewsModule(delegate)
        sceneFactory.stubbedScene.delegate?.newsSceneWillAppear()
        sceneFactory.stubbedScene.delegate?.newsSceneWillAppear()
        
        XCTAssertEqual(1, authenticationService.authStateDeterminedCount)
    }
    
}
