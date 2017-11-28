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
    private let presentationStrings: PresentationStrings

    init(delegate: PreloadModuleDelegate,
         preloadScene: SplashScene,
         preloadService: PreloadService,
         alertRouter: AlertRouter,
         quote: Quote,
         presentationStrings: PresentationStrings) {
        self.delegate = delegate
        self.preloadScene = preloadScene
        self.preloadService = preloadService
        self.alertRouter = alertRouter
        self.presentationStrings = presentationStrings

        preloadScene.delegate = self
        preloadScene.showQuote(quote.message)
        preloadScene.showQuoteAuthor(quote.author)
    }

    func splashSceneWillAppear(_ splashScene: SplashScene) {
        beginPreloading()
    }

    func preloadServiceDidFail() {
        let tryAgainAction = AlertAction(title: presentationStrings[.tryAgain], action: beginPreloading)
        let cancelAction = AlertAction(title: presentationStrings[.cancel], action: notifyDelegatePreloadingCancelled)
        let alert = Alert(title: presentationStrings[.downloadError],
                          message: presentationStrings[.preloadFailureMessage],
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
