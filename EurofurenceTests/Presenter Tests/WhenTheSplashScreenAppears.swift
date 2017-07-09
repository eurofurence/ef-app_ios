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

    private(set) var toldToMakeQuote = false
    func makeQuote() {
        toldToMakeQuote = true
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
    
}
