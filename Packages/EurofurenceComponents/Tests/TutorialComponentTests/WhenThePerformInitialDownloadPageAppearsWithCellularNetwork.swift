import EurofurenceModel
import TutorialComponent
import XCTest

class WhenThePerformInitialDownloadPageAppearsWithCellularNetwork: XCTestCase {

    var context: TutorialModuleTestBuilder.Context!

    override func setUp() {
        super.setUp()

        context = TutorialModuleTestBuilder()
            .with(CellularNetwork())
            .with(UserAcknowledgedPushPermissions())
            .build()
    }

    func testTappingThePrimaryButtonTellsAlertRouterToShowAlert() {
        context.page.simulateTappingPrimaryActionButton()
        XCTAssertTrue(context.alertRouter.didShowAlert)
    }

    func testTappingThePrimaryButtonShouldNotCompleteTutorial() {
        context.page.simulateTappingPrimaryActionButton()
        XCTAssertFalse(context.delegate.wasToldTutorialFinished)
    }

    func testTappingThePrimaryButtonTellsAlertRouterToShowAlertWithWarnUserAboutCellularDownloadsTitle() {
        context.page.simulateTappingPrimaryActionButton()
        XCTAssertEqual(context.alertRouter.presentedAlertTitle, "Use Cellular Data?")
    }

    func testTappingThePrimaryButtonTellsAlertRouterToShowAlertWithWarnUserAboutCellularDownloadsMessage() {
        context.page.simulateTappingPrimaryActionButton()
        
        XCTAssertEqual(
            context.alertRouter.presentedAlertMessage,
            "Proceeding with the initial download will consume several megabytes of data."
        )
    }

    func testTappingThePrimaryButtonTellsAlertRouterToShowAlertWithContinueDownloadOverCellularAction() {
        context.page.simulateTappingPrimaryActionButton()
        let action = context.alertRouter.presentedActions.first

        XCTAssertEqual(action?.title, "Continue Over Cellular")
    }

    func testTappingThePrimaryButtonTellsAlertRouterToShowAlertWithCancelAction() {
        context.page.simulateTappingPrimaryActionButton()
        let action = context.alertRouter.presentedActions.last

        XCTAssertEqual(action?.title, .cancel)
    }

    func testTappingThePrimaryButtonThenInvokingFirstActionShouldTellTheDelegateTheTutorialFinished() {
        context.page.simulateTappingPrimaryActionButton()
        context.alertRouter.presentedActions.first?.invoke()

        XCTAssertTrue(context.delegate.wasToldTutorialFinished)
    }

    func testTappingThePrimaryButtonThenInvokingFirstActionShouldMarkTheTutorialAsComplete() {
        context.page.simulateTappingPrimaryActionButton()
        context.alertRouter.presentedActions.first?.invoke()

        XCTAssertTrue(context.tutorialStateProviding.didMarkTutorialAsComplete)
    }

}
