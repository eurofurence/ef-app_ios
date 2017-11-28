//
//  PreloadPresenterTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class PreloadPresenterTests: XCTestCase {
    
    class PreloadPresenterTestContext {
        
        var preloadViewController: UIViewController?
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
            let factory = PhonePreloadModuleFactory(preloadSceneFactory: preloadSceneFactory,
                                                    preloadService: preloadingService,
                                                    alertRouter: alertRouter,
                                                    quoteGenerator: capturingQuoteGenerator,
                                                    presentationStrings: presentationStrings)
            preloadViewController = factory.makePreloadModule(delegate)
            
            return self
        }
        
    }
    
    func testThePreloadControllerIsReturnedFromTheFactory() {
        let context = PreloadPresenterTestContext().build()
        XCTAssertEqual(context.preloadViewController, context.preloadSceneFactory.splashScene)
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
        
        XCTAssertEqual(context.presentationStrings[.downloadError],
                       context.alertRouter.presentedAlertTitle)
    }
    
    func testWhenThePreloadServiceFailsTheAlertRouterIsToldToShowAlertWithFailedToPreloadDescription() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()
        
        XCTAssertEqual(context.presentationStrings[.preloadFailureMessage],
                       context.alertRouter.presentedAlertMessage)
    }
    
    func testWhenThePreloadServiceFailsTheAlertRouterIsToldToShowAlertWithTryAgainAction() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()
        
        XCTAssertEqual(context.presentationStrings[.tryAgain],
                       context.alertRouter.presentedActions.first?.title)
    }
    
    func testWhenThePreloadServiceFailsTheAlertRouterIsToldToShowAlertWithCancelAction() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()
        
        XCTAssertEqual(context.presentationStrings[.cancel],
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
        let cancelTitle = context.presentationStrings[.cancel]
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
        let tryAgainTitle = context.presentationStrings[.tryAgain]
        context.alertRouter.capturedAction(title: tryAgainTitle)?.invoke()
        
        XCTAssertEqual(2, context.preloadingService.beginPreloadInvocationCount)
    }
    
    func testWhenThePreloadServiceCompletesTheDelegateIsToldPreloadingFinished() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifySucceededPreload()
        
        XCTAssertTrue(context.delegate.notifiedPreloadFinished)
    }
    
    func testTheDelegateIsNotToldPreloadFinishedUntilTheServiceTellsUsSo() {
        let context = PreloadPresenterTestContext().build()
        XCTAssertFalse(context.delegate.notifiedPreloadFinished)
    }
    
    func testWhenThePreloadServiceProgressesTheSceneIsToldToUpdateWithTheCurrentAndTotalUnitCount() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        let current = Random.makeRandomNumber(upperLimit: 100)
        let total = Random.makeRandomNumber(upperLimit: 100 - current) + current
        let expected = Float(current) / Float(total)
        context.preloadingService.notifyProgressMade(current: current, total: total)
        
        XCTAssertEqual(expected, context.preloadSceneFactory.splashScene.capturedProgress)
    }
    
}
