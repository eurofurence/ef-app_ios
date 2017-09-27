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

protocol PreloadService {
    
    func beginPreloading()
    
}

class CapturingPreloadService: PreloadService {
    
    private(set) var didBeginPreloading = false
    func beginPreloading() {
        didBeginPreloading = true
    }
    
}

struct PreloadModule<SceneFactory: PreloadSceneFactory>: PresentationModule {
    
    private let preloadSceneFactory: SceneFactory
    private let quoteGenerator: QuoteGenerator
    private let preloadService: PreloadService
    
    init(preloadSceneFactory: SceneFactory,
         preloadService: PreloadService,
         quoteGenerator: QuoteGenerator) {
        self.preloadSceneFactory = preloadSceneFactory
        self.preloadService = preloadService
        self.quoteGenerator = quoteGenerator
    }
    
    func attach(to wireframe: PresentationWireframe) {
        let preloadScene = preloadSceneFactory.makePreloadScene()
        _ = PreloadPresenter(preloadScene: preloadScene,
                             preloadService: preloadService,
                             quote: quoteGenerator.makeQuote())
        wireframe.show(preloadScene)
    }
    
    private struct PreloadPresenter: SplashSceneDelegate {
        
        private let preloadService: PreloadService
        
        init(preloadScene: SplashScene, preloadService: PreloadService, quote: Quote) {
            self.preloadService = preloadService
            
            preloadScene.delegate = self
            preloadScene.showQuote(quote.message)
            preloadScene.showQuoteAuthor(quote.author)
        }
        
        func splashSceneWillAppear(_ splashScene: SplashScene) {
            preloadService.beginPreloading()
        }
        
    }
    
}

class PreloadPresenterTests: XCTestCase {
    
    struct PreloadPresenterTestContext {
        
        let preloadSceneFactory = StubPreloadSceneFactory()
        let wireframe = CapturingPresentationWireframe()
        let capturingQuoteGenerator = CapturingQuoteGenerator()
        let preloadingService = CapturingPreloadService()
        
        func with(_ quote: Quote) -> PreloadPresenterTestContext {
            capturingQuoteGenerator.quoteToMake = quote
            return self
        }
        
        func build() -> PreloadPresenterTestContext {
            let module = PreloadModule(preloadSceneFactory: preloadSceneFactory,
                                       preloadService: preloadingService,
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
    
    func testTellTheLoadingServiceToBeginLoadingWhenSceneIsAboutToAppear() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        
        XCTAssertTrue(context.preloadingService.didBeginPreloading)
    }
    
    func testWaitUntilTheSceneIsAboutToAppearBeforeBeginningPreloading() {
        let context = PreloadPresenterTestContext().build()
        XCTAssertFalse(context.preloadingService.didBeginPreloading)
    }
    
}
