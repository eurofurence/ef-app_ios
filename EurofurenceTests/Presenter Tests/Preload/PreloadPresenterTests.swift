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

protocol PreloadModuleDelegate {
    
    func preloadModuleDidCancelPreloading()
    
}

class CapturingPreloadService: PreloadService {
    
    private(set) var didBeginPreloading = false
    private(set) var beginPreloadInvocationCount = 0
    private var delegate: PreloadServiceDelegate?
    func beginPreloading(delegate: PreloadServiceDelegate) {
        self.delegate = delegate
        didBeginPreloading = true
        beginPreloadInvocationCount += 1
    }
    
    func notifyFailedToPreload() {
        delegate?.preloadServiceDidFail()
    }
    
    func notifySucceededPreload() {
        delegate?.preloadServiceDidFinish()
    }
    
}

class CapturingPreloadModuleDelegate: PreloadModuleDelegate {
    
    private(set) var notifiedPreloadCancelled = false
    func preloadModuleDidCancelPreloading() {
        notifiedPreloadCancelled = true
    }
    
}

struct PreloadModule<SceneFactory: PreloadSceneFactory>: PresentationModule {
    
    private let delegate: PreloadModuleDelegate
    private let preloadSceneFactory: SceneFactory
    private let quoteGenerator: QuoteGenerator
    private let preloadService: PreloadService
    private let alertRouter: AlertRouter
    private let presentationStrings: PresentationStrings
    
    init(delegate: PreloadModuleDelegate,
         preloadSceneFactory: SceneFactory,
         preloadService: PreloadService,
         alertRouter: AlertRouter,
         quoteGenerator: QuoteGenerator,
         presentationStrings: PresentationStrings) {
        self.delegate = delegate
        self.preloadSceneFactory = preloadSceneFactory
        self.preloadService = preloadService
        self.alertRouter = alertRouter
        self.quoteGenerator = quoteGenerator
        self.presentationStrings = presentationStrings
    }
    
    func attach(to wireframe: PresentationWireframe) {
        let preloadScene = preloadSceneFactory.makePreloadScene()
        _ = PreloadPresenter(delegate: delegate,
                             preloadScene: preloadScene,
                             preloadService: preloadService,
                             alertRouter: alertRouter,
                             quote: quoteGenerator.makeQuote(),
                             presentationStrings: presentationStrings)
        wireframe.show(preloadScene)
    }
    
    private struct PreloadPresenter: SplashSceneDelegate, PreloadServiceDelegate {
        
        private let delegate: PreloadModuleDelegate
        private let preloadService: PreloadService
        private let alertRouter: AlertRouter
        private let presentationStrings: PresentationStrings
        
        init(delegate: PreloadModuleDelegate,
             preloadScene: SplashScene,
             preloadService: PreloadService,
             alertRouter: AlertRouter,
             quote: Quote,
             presentationStrings: PresentationStrings) {
            self.delegate = delegate
            self.preloadService = preloadService
            self.alertRouter = alertRouter
            self.presentationStrings = presentationStrings
            
            preloadScene.delegate = self
            preloadScene.showQuote(quote.message)
            preloadScene.showQuoteAuthor(quote.author)
        }
        
        func splashSceneWillAppear(_ splashScene: SplashScene) {
            beginPreloading()
        }
        
        func preloadServiceDidFail() {
            let tryAgainAction = AlertAction(title: presentationStrings.presentationString(for: .tryAgain),
                                             action: beginPreloading)
            let cancelAction = AlertAction(title: presentationStrings.presentationString(for: .cancel),
                                           action: notifyDelegatePreloadingCancelled)
            alertRouter.showAlert(title: presentationStrings.presentationString(for: .downloadError),
                                  message: presentationStrings.presentationString(for: .preloadFailureMessage),
                                  actions: tryAgainAction, cancelAction)
        }
        
        func preloadServiceDidFinish() {
            
        }
        
        private func beginPreloading() {
            preloadService.beginPreloading(delegate: self)
        }
        
        private func notifyDelegatePreloadingCancelled() {
            delegate.preloadModuleDidCancelPreloading()
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
        let delegate = CapturingPreloadModuleDelegate()
        
        func with(_ quote: Quote) -> PreloadPresenterTestContext {
            capturingQuoteGenerator.quoteToMake = quote
            return self
        }
        
        func build() -> PreloadPresenterTestContext {
            let module = PreloadModule(delegate: delegate,
                                       preloadSceneFactory: preloadSceneFactory,
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
    
    func testWhenThePreloadServiceFailsTheAlertRouterIsToldToShowAlertWithTryAgainAction() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()
        
        XCTAssertEqual(context.presentationStrings.presentationString(for: .tryAgain),
                       context.alertRouter.presentedActions.first?.title)
    }
    
    func testWhenThePreloadServiceFailsTheAlertRouterIsToldToShowAlertWithCancelAction() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()
        
        XCTAssertEqual(context.presentationStrings.presentationString(for: .cancel),
                       context.alertRouter.presentedActions.last?.title)
    }
    
    func testWhenThePreloadServiceSucceedsTheAlertRouterIsNotToldToShowAlert() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifySucceededPreload()
        
        XCTAssertFalse(context.alertRouter.didShowAlert)
    }
    
    func testWhenThePreloadServiceFailsThenTheCancelActionIsInvokedTheDelegateIsToldPreloadingCancelled() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()
        let cancelTitle = context.presentationStrings.presentationString(for: .cancel)
        context.alertRouter.capturedAction(title: cancelTitle)?.invoke()
        
        XCTAssertTrue(context.delegate.notifiedPreloadCancelled)
    }
    
    func testWhenThePreloadServiceFailsTheDelegateIsNotToldPreloadCancelledUntilCancelActionInvoked() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()
        
        XCTAssertFalse(context.delegate.notifiedPreloadCancelled)
    }
    
    func testWhenThePreloadServiceFailsThenTheTryAgainActionIsInvokedThePreloadServiceIsToldToLoadAgain() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()
        let tryAgainTitle = context.presentationStrings.presentationString(for: .tryAgain)
        context.alertRouter.capturedAction(title: tryAgainTitle)?.invoke()
        
        XCTAssertEqual(2, context.preloadingService.beginPreloadInvocationCount)
    }
    
}
