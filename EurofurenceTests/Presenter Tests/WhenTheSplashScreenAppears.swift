//
//  WhenTheSplashScreenAppears.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingQuoteGenerator: QuoteGenerator {

    var quoteToMake = ""
    private(set) var toldToMakeQuote = false
    func makeQuote() -> String {
        toldToMakeQuote = true
        return quoteToMake
    }

}

class WhenTheSplashScreenAppears: XCTestCase {
    
    func testTheQuotesDataSourceIsToldToMakeQuote() {
        let capturingQuotesDataSource = CapturingQuoteGenerator()
        let context = TestingApplicationContextBuilder().withQuoteGenerator(capturingQuotesDataSource).build()
        let splashRouter = CapturingSplashScreenRouter()
        let routers = StubRouters(splashScreenRouter: splashRouter)
        BootstrappingModule.bootstrap(context: context, routers: routers)

        XCTAssertTrue(capturingQuotesDataSource.toldToMakeQuote)
    }

    func testTheQuoteFromTheGeneratorIsSetOntoTheSplashScene() {
        let someQuote = "Life is short, eat dessert first"
        let capturingQuotesDataSource = CapturingQuoteGenerator()
        capturingQuotesDataSource.quoteToMake = someQuote
        let context = TestingApplicationContextBuilder().withQuoteGenerator(capturingQuotesDataSource).build()
        let splashRouter = CapturingSplashScreenRouter()
        let routers = StubRouters(splashScreenRouter: splashRouter)
        BootstrappingModule.bootstrap(context: context, routers: routers)

        XCTAssertEqual(someQuote, splashRouter.splashScene.shownQuote)
    }
    
}
