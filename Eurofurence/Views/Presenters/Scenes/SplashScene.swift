//
//  SplashScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol SplashScene: class {

    var delegate: SplashSceneDelegate? { get set }

    func showQuote(_ quote: String)
    func showQuoteAuthor(_ author: String)
    func showProgress(_ progress: Float)

}

protocol SplashSceneDelegate {

    func splashSceneWillAppear(_ splashScene: SplashScene)

}
