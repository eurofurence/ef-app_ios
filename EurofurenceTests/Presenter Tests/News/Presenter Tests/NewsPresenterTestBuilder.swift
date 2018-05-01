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
        var sceneFactory: StubNewsSceneFactory
        var newsScene: CapturingNewsScene
        var delegate: CapturingNewsModuleDelegate
        var newsInteractor: NewsInteractor
        
    }
    
    private var sceneFactory: StubNewsSceneFactory
    private var delegate: CapturingNewsModuleDelegate
    private var newsInteractor: NewsInteractor
    
    init() {
        sceneFactory = StubNewsSceneFactory()
        delegate = CapturingNewsModuleDelegate()
        newsInteractor = FakeNewsInteractor()
    }
    
    @discardableResult
    func with(_ newsInteractor: NewsInteractor) -> NewsPresenterTestBuilder {
        self.newsInteractor = newsInteractor
        return self
    }
    
    func build() -> Context {
        let module = NewsModuleBuilder()
            .with(sceneFactory)
            .with(newsInteractor)
            .build()
            .makeNewsModule(delegate)
        
        return Context(module: module,
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
    
    @discardableResult
    func bindSceneComponent(at indexPath: IndexPath) -> Any? {
        return newsScene.bindComponent(at: indexPath)
    }
    
    func selectComponent(at indexPath: IndexPath) {
        newsScene.simulateSelectingComponent(at: indexPath)
    }
    
}

