//
//  NewsPresenterTestBuilder.swift
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
        var authService: FakeAuthenticationService
        var privateMessagesService: CapturingPrivateMessagesService
        var sceneFactory: StubNewsSceneFactory
        var newsScene: CapturingNewsScene
        var delegate: CapturingNewsModuleDelegate
        var newsInteractor: FakeNewsInteractor
        
    }
    
    private var authService: FakeAuthenticationService
    private var privateMessagesService: CapturingPrivateMessagesService
    private var sceneFactory: StubNewsSceneFactory
    private var delegate: CapturingNewsModuleDelegate
    
    init() {
        authService = FakeAuthenticationService(authState: .loggedOut)
        privateMessagesService = CapturingPrivateMessagesService()
        sceneFactory = StubNewsSceneFactory()
        delegate = CapturingNewsModuleDelegate()
    }
    
    @discardableResult
    func withUser(_ user: User = .random) -> NewsPresenterTestBuilder {
        authService = FakeAuthenticationService(authState: .loggedIn(user))
        return self
    }
    
    @discardableResult
    func with(_ privateMessagesService: CapturingPrivateMessagesService) -> NewsPresenterTestBuilder {
        self.privateMessagesService = privateMessagesService
        return self
    }
    
    func build() -> Context {
        let newsInteractor = FakeNewsInteractor()
        let module = NewsModuleBuilder()
            .with(authService)
            .with(sceneFactory)
            .with(privateMessagesService)
            .with(newsInteractor)
            .build()
            .makeNewsModule(delegate)
        
        return Context(module: module,
                       authService: authService,
                       privateMessagesService: privateMessagesService,
                       sceneFactory: sceneFactory,
                       newsScene: sceneFactory.stubbedScene,
                       delegate: delegate,
                       newsInteractor: newsInteractor)
    }
    
}

extension NewsPresenterTestBuilder.Context {
    
    func simulateNewsSceneWillAppear() {
        newsScene.delegate?.newsSceneWillAppear()
    }
    
}

