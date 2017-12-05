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
    
    var splashController: PreloadViewController!
    var delegate: CapturingSplashSceneDelegate!
    
    override func setUp() {
        super.setUp()
        
        splashController = PhonePreloadSceneFactory().makePreloadScene() as! PreloadViewController
        delegate = CapturingSplashSceneDelegate()
        splashController.delegate = delegate
        splashController.loadView()
    }
    
    func testTellingTheSceneToShowTheQuoteShouldSetItOntoTheQuoteLabel() {
        let quote = "Live long and eat pie"
        splashController.showQuote(quote)

        XCTAssertEqual(quote, splashController.quoteLabel.text)
    }
    
    func testDelegateIsToldWhenViewWillAppear() {
        splashController.viewWillAppear(false)
        XCTAssertTrue(delegate.toldSplashSceneWillAppear)
    }
    
    func testDelegateIsNotToldViewAppearedTooSoon() {
        XCTAssertFalse(delegate.toldSplashSceneWillAppear)
    }
    
}
