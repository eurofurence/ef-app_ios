//
//  WhenTheSplashScreenAppears.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenTheSplashScreenAppears: XCTestCase {
    
    func testTheQuotesDataSourceIsToldToMakeQuote() {
        let capturingQuotesDataSource = CapturingQuoteGenerator()
        let splashRouter = CapturingSplashScreenRouter()
        let routers = StubRouters(splashScreenRouter: splashRouter)
        PresentationTestBuilder()
            .withRouters(routers)
            .withQuoteGenerator(capturingQuotesDataSource)
            .build()
            .bootstrap()

        XCTAssertTrue(capturingQuotesDataSource.toldToMakeQuote)
    }

    func testTheQuoteFromTheGeneratorIsSetOntoTheSplashScene() {
        let someQuote = Quote(author: "", message: "Life is short, eat dessert first")
        let capturingQuotesDataSource = CapturingQuoteGenerator()
        capturingQuotesDataSource.quoteToMake = someQuote
        let splashRouter = CapturingSplashScreenRouter()
        let routers = StubRouters(splashScreenRouter: splashRouter)
        PresentationTestBuilder()
            .withRouters(routers)
            .withQuoteGenerator(capturingQuotesDataSource)
            .build()
            .bootstrap()

        XCTAssertEqual(someQuote.message, splashRouter.splashScene.shownQuote)
    }

    func testTheQuoteAuthorFromTheGeneratorIsSetOntoTheSplashScene() {
        let someQuote = Quote(author: "A wise man", message: "Life is short, eat dessert first")
        let capturingQuotesDataSource = CapturingQuoteGenerator()
        capturingQuotesDataSource.quoteToMake = someQuote
        let splashRouter = CapturingSplashScreenRouter()
        let routers = StubRouters(splashScreenRouter: splashRouter)
        PresentationTestBuilder()
            .withRouters(routers)
            .withQuoteGenerator(capturingQuotesDataSource)
            .build()
            .bootstrap()

        XCTAssertEqual(someQuote.author, splashRouter.splashScene.shownQuoteAuthor)
    }
    
}
