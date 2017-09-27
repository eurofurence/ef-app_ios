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
    
    func beginPreloading(delegate: PreloadServiceDelegate)
    
}

protocol PreloadServiceDelegate {
    
    func preloadServiceDidFail()
    func preloadServiceDidFinish()
    
}

class CapturingPreloadService: PreloadService {
    
    private(set) var didBeginPreloading = false
    private var delegate: PreloadServiceDelegate?
    func beginPreloading(delegate: PreloadServiceDelegate) {
        self.delegate = delegate
        didBeginPreloading = true
    }
    
    func notifyFailedToPreload() {
        delegate?.preloadServiceDidFail()
    }
    
    func notifySucceededPreload() {
        delegate?.preloadServiceDidFinish()
    }
    
}

struct PreloadModule<SceneFactory: PreloadSceneFactory>: PresentationModule {
    
    private let preloadSceneFactory: SceneFactory
    private let quoteGenerator: QuoteGenerator
    private let preloadService: PreloadService
    private let alertRouter: AlertRouter
    private let presentationStrings: PresentationStrings
    
    init(preloadSceneFactory: SceneFactory,
         preloadService: PreloadService,
         alertRouter: AlertRouter,
         quoteGenerator: QuoteGenerator,
         presentationStrings: PresentationStrings) {
        self.preloadSceneFactory = preloadSceneFactory
        self.preloadService = preloadService
        self.alertRouter = alertRouter
        self.quoteGenerator = quoteGenerator
        self.presentationStrings = presentationStrings
    }
    
    func attach(to wireframe: PresentationWireframe) {
        let preloadScene = preloadSceneFactory.makePreloadScene()
        _ = PreloadPresenter(preloadScene: preloadScene,
                             preloadService: preloadService,
                             alertRouter: alertRouter,
                             quote: quoteGenerator.makeQuote(),
                             presentationStrings: presentationStrings)
        wireframe.show(preloadScene)
    }
    
    private struct PreloadPresenter: SplashSceneDelegate, PreloadServiceDelegate {
        
        private let preloadService: PreloadService
        private let alertRouter: AlertRouter
        private let presentationStrings: PresentationStrings
        
        init(preloadScene: SplashScene,
             preloadService: PreloadService,
             alertRouter: AlertRouter,
             quote: Quote,
             presentationStrings: PresentationStrings) {
            self.preloadService = preloadService
            self.alertRouter = alertRouter
            self.presentationStrings = presentationStrings
            
            preloadScene.delegate = self
            preloadScene.showQuote(quote.message)
            preloadScene.showQuoteAuthor(quote.author)
        }
        
        func splashSceneWillAppear(_ splashScene: SplashScene) {
            preloadService.beginPreloading(delegate: self)
        }
        
        func preloadServiceDidFail() {
            let cancelAction = AlertAction(title: presentationStrings.presentationString(for: .cancel))
            alertRouter.showAlert(title: presentationStrings.presentationString(for: .downloadError),
                                  message: presentationStrings.presentationString(for: .preloadFailureMessage),
                                  actions: cancelAction)
        }
        
        func preloadServiceDidFinish() {
            
        }
        
    }
    
}

class PreloadPresenterTests: XCTestCase {
    
    struct PreloadPresenterTestContext {
        
        let preloadSceneFactory = StubPreloadSceneFactory()
        let wireframe = CapturingPresentationWireframe()
        let capturingQuoteGenerator = CapturingQuoteGenerator()
        let preloadingService = CapturingPreloadService()
        let presentationStrings = UnlocalizedPresentationStrings()
        let alertRouter = CapturingAlertRouter()
        
        func with(_ quote: Quote) -> PreloadPresenterTestContext {
            capturingQuoteGenerator.quoteToMake = quote
            return self
        }
        
        func build() -> PreloadPresenterTestContext {
            let module = PreloadModule(preloadSceneFactory: preloadSceneFactory,
                                       preloadService: preloadingService,
                                       alertRouter: alertRouter,
                                       quoteGenerator: capturingQuoteGenerator,
                                       presentationStrings: presentationStrings)
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
    
    func testWhenThePreloadServiceFailsTheAlertRouterIsToldToShowAlertWithDownloadErrorTitle() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()
        
        XCTAssertEqual(context.presentationStrings.presentationString(for: .downloadError),
                       context.alertRouter.presentedAlertTitle)
    }
    
    func testWhenThePreloadServiceFailsTheAlertRouterIsToldToShowAlertWithFailedToPreloadDescription() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()
        
        XCTAssertEqual(context.presentationStrings.presentationString(for: .preloadFailureMessage),
                       context.alertRouter.presentedAlertMessage)
    }
    
    func testWhenThePreloadServiceFailsTheAlertRouterIsToldToShowAlertWithCancelAction() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()
        
        XCTAssertEqual(context.presentationStrings.presentationString(for: .cancel),
                       context.alertRouter.presentedActions.first?.title)
    }
    
    func testWhenThePreloadServiceSucceedsTheAlertRouterIsNotToldToShowAlert() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifySucceededPreload()
        
        XCTAssertFalse(context.alertRouter.didShowAlert)
    }
    
}
