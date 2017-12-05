//
//  PreloadViewControllerTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class PreloadViewControllerTests: XCTestCase {
    
    var preloadViewController: PreloadViewController!
    var delegate: CapturingSplashSceneDelegate!
    
    override func setUp() {
        super.setUp()
        
        preloadViewController = PhonePreloadSceneFactory().makePreloadScene() as! PreloadViewController
        delegate = CapturingSplashSceneDelegate()
        preloadViewController.delegate = delegate
        preloadViewController.loadView()
    }
    
    func testTellingTheSceneToShowTheQuoteShouldSetItOntoTheQuoteLabel() {
        let quote = "Live long and eat pie"
        preloadViewController.showQuote(quote)

        XCTAssertEqual(quote, preloadViewController.quoteLabel.text)
    }
    
    func testDelegateIsToldWhenViewWillAppear() {
        preloadViewController.viewWillAppear(false)
        XCTAssertTrue(delegate.toldSplashSceneWillAppear)
    }
    
    func testDelegateIsNotToldViewAppearedTooSoon() {
        XCTAssertFalse(delegate.toldSplashSceneWillAppear)
    }
    
    func testTellingTheSceneToShowTheQuoteAuthorShouldSetItOntoTheQuoteAuthorLabel() {
        let author = "Some Guy"
        preloadViewController.showQuoteAuthor(author)
        
        XCTAssertEqual(author, preloadViewController.quoteAuthorLabel.text)
    }
    
    func testTellingTheSceneToShowProgressSetsTheProgressOnTheProgressBar() {
        let progress = Float(arc4random_uniform(100) / 100)
        preloadViewController.showProgress(progress)
        
        XCTAssertEqual(progress, preloadViewController.progressBar.progress)
    }
    
}
