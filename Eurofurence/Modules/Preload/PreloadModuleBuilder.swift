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
    private var preloadService: PreloadInteractor
    private var alertRouter: AlertRouter

    init() {
        preloadSceneFactory = StoryboardPreloadSceneFactory()
        preloadService = ApplicationPreloadInteractor()
        alertRouter = WindowAlertRouter.shared
    }

    func with(_ preloadSceneFactory: PreloadSceneFactory) -> PreloadModuleBuilder {
        self.preloadSceneFactory = preloadSceneFactory
        return self
    }

    func with(_ preloadService: PreloadInteractor) -> PreloadModuleBuilder {
        self.preloadService = preloadService
        return self
    }

    func with(_ alertRouter: AlertRouter) -> PreloadModuleBuilder {
        self.alertRouter = alertRouter
        return self
    }

    func build() -> PreloadModuleProviding {
        return PreloadModule(preloadSceneFactory: preloadSceneFactory,
                             preloadService: preloadService,
                             alertRouter: alertRouter)
    }

}
