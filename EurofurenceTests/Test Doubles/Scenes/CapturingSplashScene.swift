//
//  CapturingSplashScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingSplashScene: SplashScene {
    
    var delegate: SplashSceneDelegate?

    private(set) var shownQuote: String?
    func showQuote(_ quote: String) {
        shownQuote = quote
    }

    private(set) var shownQuoteAuthor: String?
    func showQuoteAuthor(_ author: String) {
        shownQuoteAuthor = author
    }
    
    func notifySceneWillAppear() {
        delegate?.splashSceneWillAppear(self)
    }
    
}
