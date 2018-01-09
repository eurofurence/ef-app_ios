//
//  PreloadPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 01/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

struct PreloadPresenter: SplashSceneDelegate, PreloadServiceDelegate {

    private let delegate: PreloadModuleDelegate
    private let preloadScene: SplashScene
    private let preloadService: PreloadService
    private let alertRouter: AlertRouter
    private let quote: Quote

    init(delegate: PreloadModuleDelegate,
         preloadScene: SplashScene,
         preloadService: PreloadService,
         alertRouter: AlertRouter,
         quote: Quote) {
        self.delegate = delegate
        self.preloadScene = preloadScene
        self.preloadService = preloadService
        self.alertRouter = alertRouter
        self.quote = quote

        preloadScene.delegate = self
    }

    func splashSceneWillAppear(_ splashScene: SplashScene) {
        preloadScene.showQuote(quote.message)
        preloadScene.showQuoteAuthor(quote.author)
        beginPreloading()
    }

    func preloadServiceDidFail() {
        let tryAgainAction = AlertAction(title: .tryAgain, action: beginPreloading)
        let cancelAction = AlertAction(title: .cancel, action: notifyDelegatePreloadingCancelled)
        let alert = Alert(title: .downloadError,
                          message: .preloadFailureMessage,
                          actions: [tryAgainAction, cancelAction])
        alertRouter.show(alert)
    }

    func preloadServiceDidFinish() {
        delegate.preloadModuleDidFinishPreloading()
    }

    func preloadServiceDidProgress(currentUnitCount: Int, totalUnitCount: Int) {
        let fractionalProgress = Float(currentUnitCount) / Float(totalUnitCount)
        preloadScene.showProgress(fractionalProgress)
    }

    private func beginPreloading() {
        preloadService.beginPreloading(delegate: self)
    }

    private func notifyDelegatePreloadingCancelled() {
        delegate.preloadModuleDidCancelPreloading()
    }

}
