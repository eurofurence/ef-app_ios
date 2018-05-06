//
//  PreloadModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 01/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol PreloadModuleDelegate {

    func preloadModuleDidCancelPreloading()
    func preloadModuleDidFinishPreloading()

}

struct PreloadModule {

    private let delegate: PreloadModuleDelegate
    private let preloadSceneFactory: PreloadSceneFactory
    private let quoteGenerator: QuoteGenerator
    private let preloadService: PreloadInteractor
    private let alertRouter: AlertRouter

    init(delegate: PreloadModuleDelegate,
         preloadSceneFactory: PreloadSceneFactory,
         preloadService: PreloadInteractor,
         alertRouter: AlertRouter,
         quoteGenerator: QuoteGenerator) {
        self.delegate = delegate
        self.preloadSceneFactory = preloadSceneFactory
        self.preloadService = preloadService
        self.alertRouter = alertRouter
        self.quoteGenerator = quoteGenerator
    }

    func attach() {
        let preloadScene = preloadSceneFactory.makePreloadScene()
        _ = PreloadPresenter(delegate: delegate,
                             preloadScene: preloadScene,
                             preloadService: preloadService,
                             alertRouter: alertRouter,
                             quote: quoteGenerator.makeQuote())
    }

}
