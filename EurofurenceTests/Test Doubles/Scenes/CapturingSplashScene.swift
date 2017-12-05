//
//  CapturingSplashScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class StubPreloadSceneFactory: PreloadSceneFactory {
    
    let splashScene = CapturingSplashScene()
    func makePreloadScene() -> UIViewController & SplashScene {
        return splashScene
    }
    
}

class CapturingSplashScene: UIViewController, SplashScene {
    
    var delegate: SplashSceneDelegate?

    private(set) var shownQuote: String?
    func showQuote(_ quote: String) {
        shownQuote = quote
    }

    private(set) var shownQuoteAuthor: String?
    func showQuoteAuthor(_ author: String) {
        shownQuoteAuthor = author
    }
    
    private(set) var capturedProgress: Float?
    func showProgress(_ progress: Float) {
        capturedProgress = progress
    }
    
    func notifySceneWillAppear() {
        delegate?.splashSceneWillAppear(self)
    }
    
}

class CapturingSplashSceneDelegate: SplashSceneDelegate {
    
    private(set) var toldSplashSceneWillAppear = false
    func splashSceneWillAppear(_ splashScene: SplashScene) {
        toldSplashSceneWillAppear = true
    }
    
}
