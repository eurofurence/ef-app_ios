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
    
    func testTheAuthServiceIsNotDeterminedWhenSceneWillReappearAgain() {
        let sceneFactory = StubNewsSceneFactory()
        let authenticationService = FakeAuthenticationService(authState: .loggedOut)
        let delegate = CapturingNewsModuleDelegate()
        _ = NewsModuleBuilder()
            .with(sceneFactory)
            .with(authenticationService)
            .with(CapturingPrivateMessagesService())
            .build()
            .makeNewsModule(delegate)
        sceneFactory.stubbedScene.delegate?.newsSceneWillAppear()
        sceneFactory.stubbedScene.delegate?.newsSceneWillAppear()
        
        XCTAssertEqual(1, authenticationService.authStateDeterminedCount)
    }
    
    func testTheSceneIsToldToShowTheNewsTitle() {
        let sceneFactory = StubNewsSceneFactory()
        let authenticationService = FakeAuthenticationService(authState: .loggedOut)
        let delegate = CapturingNewsModuleDelegate()
        _ = NewsModuleBuilder()
            .with(sceneFactory)
            .with(authenticationService)
            .with(CapturingPrivateMessagesService())
            .build()
            .makeNewsModule(delegate)
        let expected: String = .news
        
        XCTAssertEqual(expected, sceneFactory.stubbedScene.capturedTitle)
    }
    
}
