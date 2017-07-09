//
//  SplashViewControllerTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class SplashViewControllerTests: XCTestCase {
    
    func testTellingTheSceneToShowTheQuoteShouldSetItOntoTheQuoteLabel() {
        let bundle = Bundle(for: SplashViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let splashController = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        splashController.loadView()
        let quote = "Live long and eat pie"
        splashController.showQuote(quote)

        XCTAssertEqual(quote, splashController.quoteLabel.text)
    }
    
}
