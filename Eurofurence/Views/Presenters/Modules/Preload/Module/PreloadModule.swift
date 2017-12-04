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
    private let preloadService: PreloadService
    private let alertRouter: AlertRouter
    private let presentationStrings: PresentationStrings

    init(delegate: PreloadModuleDelegate,
         preloadSceneFactory: PreloadSceneFactory,
         preloadService: PreloadService,
         alertRouter: AlertRouter,
         quoteGenerator: QuoteGenerator,
         presentationStrings: PresentationStrings) {
        self.delegate = delegate
        self.preloadSceneFactory = preloadSceneFactory
        self.preloadService = preloadService
        self.alertRouter = alertRouter
        self.quoteGenerator = quoteGenerator
        self.presentationStrings = presentationStrings
    }

    func attach() {
        let preloadScene = preloadSceneFactory.makePreloadScene()
        _ = PreloadPresenter(delegate: delegate,
                             preloadScene: preloadScene,
                             preloadService: preloadService,
                             alertRouter: alertRouter,
                             quote: quoteGenerator.makeQuote(),
                             presentationStrings: presentationStrings)
    }

}
