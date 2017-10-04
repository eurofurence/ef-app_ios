//
//  PhonePreloadModuleFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

struct PhonePreloadModuleFactory<SceneFactory: PreloadSceneFactory>: PreloadModuleFactory {

    private let preloadSceneFactory: SceneFactory
    private let preloadService: PreloadService
    private let alertRouter: AlertRouter
    private let quoteGenerator: QuoteGenerator
    private let presentationStrings: PresentationStrings

    init(preloadSceneFactory: SceneFactory,
         preloadService: PreloadService,
         alertRouter: AlertRouter,
         quoteGenerator: QuoteGenerator,
         presentationStrings: PresentationStrings) {
        self.preloadSceneFactory = preloadSceneFactory
        self.preloadService = preloadService
        self.alertRouter = alertRouter
        self.quoteGenerator = quoteGenerator
        self.presentationStrings = presentationStrings
    }

    func makePreloadModule(_ delegate: PreloadModuleDelegate) -> UIViewController {
        let preloadScene = preloadSceneFactory.makePreloadScene()
        _ = PreloadPresenter(delegate: delegate,
                             preloadScene: preloadScene,
                             preloadService: preloadService,
                             alertRouter: alertRouter,
                             quote: quoteGenerator.makeQuote(),
                             presentationStrings: presentationStrings)

        return UIViewController()
    }

}
