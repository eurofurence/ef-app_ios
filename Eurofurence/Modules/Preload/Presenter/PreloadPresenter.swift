//
//  PreloadPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 01/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

struct PreloadPresenter: SplashSceneDelegate, PreloadInteractorDelegate {

    private let delegate: PreloadModuleDelegate
    private let preloadScene: SplashScene
    private let preloadService: PreloadInteractor
    private let alertRouter: AlertRouter

    init(delegate: PreloadModuleDelegate,
         preloadScene: SplashScene,
         preloadService: PreloadInteractor,
         alertRouter: AlertRouter) {
        self.delegate = delegate
        self.preloadScene = preloadScene
        self.preloadService = preloadService
        self.alertRouter = alertRouter

        preloadScene.delegate = self
    }

    func splashSceneWillAppear(_ splashScene: SplashScene) {
        beginPreloading()
    }

    func preloadInteractorDidFailToPreload() {
        let tryAgainAction = AlertAction(title: .tryAgain, action: beginPreloading)
        let cancelAction = AlertAction(title: .cancel, action: notifyDelegatePreloadingCancelled)
        let alert = Alert(title: .downloadError,
                          message: .preloadFailureMessage,
                          actions: [tryAgainAction, cancelAction])
        alertRouter.show(alert)
    }

    func preloadInteractorDidFinishPreloading() {
        delegate.preloadModuleDidFinishPreloading()
    }

    func preloadInteractorDidProgress(currentUnitCount: Int, totalUnitCount: Int, localizedDescription: String) {
        let fractionalProgress = Float(currentUnitCount) / Float(totalUnitCount)
        preloadScene.showProgress(fractionalProgress, progressDescription: localizedDescription)
    }

    private func beginPreloading() {
        preloadService.beginPreloading(delegate: self)
    }

    private func notifyDelegatePreloadingCancelled() {
        delegate.preloadModuleDidCancelPreloading()
    }

}
