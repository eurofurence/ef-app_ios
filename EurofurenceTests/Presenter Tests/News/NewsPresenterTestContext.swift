//
//  NewsPresenterTestContext.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class NewsPresenterTestBuilder {
    
    struct Context {
        
        var module: UIViewController
        var authService: StubAuthenticationService
        var privateMessagesService: CapturingPrivateMessagesService
        var sceneFactory: StubNewsSceneFactory
        var newsScene: CapturingNewsScene
        var delegate: CapturingNewsModuleDelegate
        
    }
    
    private var authService: StubAuthenticationService
    private var privateMessagesService: CapturingPrivateMessagesService
    private var sceneFactory: StubNewsSceneFactory
    private var delegate: CapturingNewsModuleDelegate
    
    init() {
        authService = StubAuthenticationService(authState: .loggedOut)
        privateMessagesService = CapturingPrivateMessagesService()
        sceneFactory = StubNewsSceneFactory()
        delegate = CapturingNewsModuleDelegate()
    }
    
    @discardableResult
    func withUser(_ user: User = .random) -> NewsPresenterTestBuilder {
        authService = StubAuthenticationService(authState: .loggedIn(user))
        return self
    }
    
    @discardableResult
    func with(_ privateMessagesService: CapturingPrivateMessagesService) -> NewsPresenterTestBuilder {
        self.privateMessagesService = privateMessagesService
        return self
    }
    
    func build() -> Context {
        let module = NewsModuleBuilder()
            .with(authService)
            .with(sceneFactory)
            .with(privateMessagesService)
            .build()
            .makeNewsModule(delegate)
        
        return Context(module: module,
                       authService: authService,
                       privateMessagesService: privateMessagesService,
                       sceneFactory: sceneFactory,
                       newsScene: sceneFactory.stubbedScene,
                       delegate: delegate)
    }
    
}

extension NewsPresenterTestBuilder.Context {
    
    func simulateNewsSceneWillAppear() {
        newsScene.delegate?.newsSceneWillAppear()
    }
    
}

struct NewsPresenterTestContext {
    
    let authService: StubAuthenticationService
    let privateMessagesService: CapturingPrivateMessagesService
    let sceneFactory = StubNewsSceneFactory()
    let delegate = CapturingNewsModuleDelegate()
    
    var newsScene: CapturingNewsScene { return sceneFactory.stubbedScene }
    
    @discardableResult
    static func makeTestCaseForAuthenticatedUser(_ user: User = User(registrationNumber: 42, username: ""),
                                                 privateMessagesService: CapturingPrivateMessagesService = CapturingPrivateMessagesService()) -> NewsPresenterTestContext {
        return NewsPresenterTestContext(authenticationService: StubAuthenticationService(authState: .loggedIn(user)),
                                      privateMessagesService: privateMessagesService)
    }
    
    @discardableResult
    static func makeTestCaseForAnonymousUser() -> NewsPresenterTestContext {
        return NewsPresenterTestContext(authenticationService: StubAuthenticationService(authState: .loggedOut),
                                      privateMessagesService: CapturingPrivateMessagesService())
    }
    
    private init(authenticationService: StubAuthenticationService,
                 privateMessagesService: CapturingPrivateMessagesService) {
        self.authService = authenticationService
        self.privateMessagesService = privateMessagesService
        _ = NewsModuleBuilder()
            .with(sceneFactory)
            .with(authenticationService)
            .with(privateMessagesService)
            .build()
            .makeNewsModule(delegate)
        sceneFactory.stubbedScene.delegate?.newsSceneWillAppear()
    }
    
}
