//
//  NewsPresenterTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class NewsPresenterTests: XCTestCase {
    
    func testTheAuthServiceIsNotToldToDetermineAuthStateUntilViewWillAppear() {
        let sceneFactory = StubNewsSceneFactory()
        let authenticationService = CapturingAuthenticationService()
        let delegate = CapturingNewsModuleDelegate()
        _ = NewsModuleBuilder()
            .with(sceneFactory)
            .with(authenticationService)
            .with(CapturingPrivateMessagesService())
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
            .with(CapturingPrivateMessagesService())
            .with(CapturingWelcomePromptStringFactory())
            .build()
            .makeNewsModule(delegate)
        sceneFactory.stubbedScene.delegate?.newsSceneWillAppear()
        sceneFactory.stubbedScene.delegate?.newsSceneWillAppear()
        
        XCTAssertEqual(1, authenticationService.authStateDeterminedCount)
    }
    
}
