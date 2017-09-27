//
//  PreloadPresenterTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class StubPreloadSceneFactory: PreloadSceneFactory {
    
    typealias Scene = CapturingSplashScene
    
    let splashScene = CapturingSplashScene()
    func makePreloadScene() -> StubPreloadSceneFactory.Scene {
        return splashScene
    }
    
}

struct PreloadModule<SceneFactory: PreloadSceneFactory>: PresentationModule {
    
    private let preloadSceneFactory: SceneFactory
    private let quoteGenerator: QuoteGenerator
    
    init(preloadSceneFactory: SceneFactory,
         quoteGenerator: QuoteGenerator) {
        self.preloadSceneFactory = preloadSceneFactory
        self.quoteGenerator = quoteGenerator
    }
    
    func attach(to wireframe: PresentationWireframe) {
        let preloadScene = preloadSceneFactory.makePreloadScene()
        wireframe.show(preloadScene)
        
        let quote = quoteGenerator.makeQuote()
        preloadScene.showQuote(quote.message)
        preloadScene.showQuoteAuthor(quote.author)
    }
    
}

class PreloadPresenterTests: XCTestCase {
    
    func testThePreloadSceneIsSetOntoTheWireframe() {
        let preloadSceneFactory = StubPreloadSceneFactory()
        let wireframe = CapturingPresentationWireframe()
        let preloadModule = PreloadModule(preloadSceneFactory: preloadSceneFactory,
                                          quoteGenerator: CapturingQuoteGenerator())
        preloadModule.attach(to: wireframe)
        
        XCTAssertTrue(preloadSceneFactory.splashScene === wireframe.capturedRootScene)
    }
    
    func testTheQuotesDataSourceIsToldToMakeQuote() {
        let capturingQuoteGenerator = CapturingQuoteGenerator()
        let preloadSceneFactory = StubPreloadSceneFactory()
        let wireframe = CapturingPresentationWireframe()
        let preloadModule = PreloadModule(preloadSceneFactory: preloadSceneFactory,
                                          quoteGenerator: capturingQuoteGenerator)
        preloadModule.attach(to: wireframe)
        
        XCTAssertTrue(capturingQuoteGenerator.toldToMakeQuote)
    }
    
    func testTheQuoteFromTheGeneratorIsSetOntoTheSplashScene() {
        let someQuote = Quote(author: "", message: "Life is short, eat dessert first")
        let capturingQuoteGenerator = CapturingQuoteGenerator()
        capturingQuoteGenerator.quoteToMake = someQuote
        let preloadSceneFactory = StubPreloadSceneFactory()
        let wireframe = CapturingPresentationWireframe()
        let preloadModule = PreloadModule(preloadSceneFactory: preloadSceneFactory,
                                          quoteGenerator: capturingQuoteGenerator)
        preloadModule.attach(to: wireframe)
        
        XCTAssertEqual(someQuote.message, preloadSceneFactory.splashScene.shownQuote)
    }
    
    func testTheQuoteAuthorFromTheGeneratorIsSetOntoTheSplashScene() {
        let someQuote = Quote(author: "A wise man", message: "Life is short, eat dessert first")
        let capturingQuoteGenerator = CapturingQuoteGenerator()
        capturingQuoteGenerator.quoteToMake = someQuote
        let preloadSceneFactory = StubPreloadSceneFactory()
        let wireframe = CapturingPresentationWireframe()
        let preloadModule = PreloadModule(preloadSceneFactory: preloadSceneFactory,
                                          quoteGenerator: capturingQuoteGenerator)
        preloadModule.attach(to: wireframe)

        XCTAssertEqual(someQuote.author, preloadSceneFactory.splashScene.shownQuoteAuthor)
    }
    
}
