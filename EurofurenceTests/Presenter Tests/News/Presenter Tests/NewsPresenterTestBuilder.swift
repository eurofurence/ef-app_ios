//
//  NewsPresenterTestBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
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

extension NewsPresenterTestBuilder {

    static func buildForAssertingAgainstEventComponent(eventViewModel: EventComponentViewModel) -> CapturingScheduleEventComponent {
        let viewModel = SingleEventNewsViewModel(event: eventViewModel)
        let indexPath = IndexPath(item: 0, section: 0)
        let newsInteractor = StubNewsInteractor(viewModel: viewModel)
        let context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)

        return context.newsScene.stubbedEventComponent
    }

}

extension NewsPresenterTestBuilder.Context {

    func simulateNewsSceneDidLoad() {
        newsScene.delegate?.newsSceneDidLoad()
    }

    func simulateNewsSceneDidPerformRefreshAction() {
        newsScene.delegate?.newsSceneDidPerformRefreshAction()
    }

    @discardableResult
    func bindSceneComponent(at indexPath: IndexPath) -> Any? {
        return newsScene.bindComponent(at: indexPath)
    }

    func selectComponent(at indexPath: IndexPath) {
        newsScene.simulateSelectingComponent(at: indexPath)
    }

}
