//
//  PreloadModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIApplication

class PreloadModuleBuilder {

    private var preloadSceneFactory: PreloadSceneFactory
    private var preloadService: PreloadService
    private var alertRouter: AlertRouter
    private var quoteGenerator: QuoteGenerator

    init() {
        preloadSceneFactory = PhonePreloadSceneFactory()
        preloadService = ApplicationPreloadingService()
        alertRouter = WindowAlertRouter.shared
        quoteGenerator = EgyptianQuoteGenerator()
    }

    func with(_ preloadSceneFactory: PreloadSceneFactory) -> PreloadModuleBuilder {
        self.preloadSceneFactory = preloadSceneFactory
        return self
    }

    func with(_ preloadService: PreloadService) -> PreloadModuleBuilder {
        self.preloadService = preloadService
        return self
    }

    func with(_ alertRouter: AlertRouter) -> PreloadModuleBuilder {
        self.alertRouter = alertRouter
        return self
    }

    func with(_ quoteGenerator: QuoteGenerator) -> PreloadModuleBuilder {
        self.quoteGenerator = quoteGenerator
        return self
    }

    func build() -> PreloadModuleProviding {
        return PhonePreloadModuleFactory(preloadSceneFactory: preloadSceneFactory,
                                         preloadService: preloadService,
                                         alertRouter: alertRouter,
                                         quoteGenerator: quoteGenerator)

    }

}
