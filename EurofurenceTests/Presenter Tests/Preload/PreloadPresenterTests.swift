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
        _ = PreloadPresenter(preloadScene: preloadScene, quote: quoteGenerator.makeQuote())
        wireframe.show(preloadScene)
    }
    
    private struct PreloadPresenter {
        
        init(preloadScene: SplashScene, quote: Quote) {
            preloadScene.showQuote(quote.message)
            preloadScene.showQuoteAuthor(quote.author)
        }
        
    }
    
}

class PreloadPresenterTests: XCTestCase {
    
    struct PreloadPresenterTestContext {
        
        let preloadSceneFactory = StubPreloadSceneFactory()
        let wireframe = CapturingPresentationWireframe()
        let capturingQuoteGenerator = CapturingQuoteGenerator()
        
        func with(_ quote: Quote) -> PreloadPresenterTestContext {
            capturingQuoteGenerator.quoteToMake = quote
            return self
        }
        
        func build() -> PreloadPresenterTestContext {
            let module = PreloadModule(preloadSceneFactory: preloadSceneFactory,
                                       quoteGenerator: capturingQuoteGenerator)
            module.attach(to: wireframe)
            
            return self
        }
        
    }
    
    func testThePreloadSceneIsSetOntoTheWireframe() {
        let context = PreloadPresenterTestContext().build()
        XCTAssertTrue(context.preloadSceneFactory.splashScene === context.wireframe.capturedRootScene)
    }
    
    func testTheQuotesDataSourceIsToldToMakeQuote() {
        let context = PreloadPresenterTestContext().build()
        XCTAssertTrue(context.capturingQuoteGenerator.toldToMakeQuote)
    }
    
    func testTheQuoteFromTheGeneratorIsSetOntoTheSplashScene() {
        let someQuote = Quote(author: "", message: "Life is short, eat dessert first")
        let context = PreloadPresenterTestContext().with(someQuote).build()
        
        XCTAssertEqual(someQuote.message, context.preloadSceneFactory.splashScene.shownQuote)
    }
    
    func testTheQuoteAuthorFromTheGeneratorIsSetOntoTheSplashScene() {
        let someQuote = Quote(author: "A wise man", message: "Life is short, eat dessert first")
        let context = PreloadPresenterTestContext().with(someQuote).build()

        XCTAssertEqual(someQuote.author, context.preloadSceneFactory.splashScene.shownQuoteAuthor)
    }
    
}
