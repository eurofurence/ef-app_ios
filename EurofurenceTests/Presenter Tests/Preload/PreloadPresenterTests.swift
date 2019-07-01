@testable import Eurofurence
import EurofurenceModel
import XCTest

class PreloadPresenterTests: XCTestCase {

    class PreloadPresenterTestContext {

        var preloadViewController: UIViewController?
        let preloadSceneFactory = StubPreloadSceneFactory()
        let preloadingService = CapturingPreloadInteractor()
        let alertRouter = CapturingAlertRouter()
        let delegate = CapturingPreloadModuleDelegate()

        func build() -> PreloadPresenterTestContext {
            preloadViewController = PreloadModuleBuilder(preloadInteractor: preloadingService)
                .with(preloadSceneFactory)
                .with(alertRouter)
                .build()
                .makePreloadModule(delegate)

            return self
        }

    }

    func testThePreloadControllerIsReturnedFromTheFactory() {
        let context = PreloadPresenterTestContext().build()
        XCTAssertEqual(context.preloadViewController, context.preloadSceneFactory.splashScene)
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

        XCTAssertEqual(.downloadError,
                       context.alertRouter.presentedAlertTitle)
    }

    func testWhenThePreloadServiceFailsTheAlertRouterIsToldToShowAlertWithFailedToPreloadDescription() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()

        XCTAssertEqual(.preloadFailureMessage,
                       context.alertRouter.presentedAlertMessage)
    }

    func testWhenThePreloadServiceFailsTheAlertRouterIsToldToShowAlertWithTryAgainAction() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()

        XCTAssertEqual(context.alertRouter.presentedActions.first?.title, .tryAgain)
    }

    func testWhenThePreloadServiceFailsTheAlertRouterIsToldToShowAlertWithCancelAction() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()

        XCTAssertEqual(context.alertRouter.presentedActions.last?.title, .cancel)
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
        context.alertRouter.capturedAction(title: .cancel)?.invoke()

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
        context.alertRouter.capturedAction(title: .tryAgain)?.invoke()

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

    func testWhenThePreloadServiceProgressesTheSceneIsToldToUpdateWithTheLatestInformation() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        let current = UInt32.random(upperLimit: 100)
        let total = UInt32.random(upperLimit: 100 - current) + current
        let localizedDescription = String.random
        let expected = Float(current) / Float(total)
        context.preloadingService.notifyProgressMade(current: Int(current),
                                                     total: Int(total),
                                                     localizedDescription: localizedDescription)

        XCTAssertEqual(expected, context.preloadSceneFactory.splashScene.capturedProgress)
        XCTAssertEqual(localizedDescription, context.preloadSceneFactory.splashScene.capturedProgressDescription)
    }
    
    func testConventionIdentifierMismatchShowsStaleAppAlert() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.simulateOldAppError()
        
        XCTAssertTrue(context.preloadSceneFactory.splashScene.didShowStaleAppAlert)
        XCTAssertTrue(context.delegate.notifiedPreloadCancelled)
    }

}
