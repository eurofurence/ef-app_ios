import TutorialComponent
import XCTest

class WhenThePerformInitialDownloadPageAppears: XCTestCase {

    var context: TutorialModuleTestBuilder.Context!

    override func setUp() {
        super.setUp()

        context = TutorialModuleTestBuilder()
            .with(UserAcknowledgedPushPermissions())
            .build()
    }

    func testShouldTellTheFirstTutorialPageToShowTheTitleForBeginningInitialLoad() {
        XCTAssertEqual("Offline Usage", context.page.capturedPageTitle)
    }

    func testShouldTellTheFirstTutorialPageToShowTheDescriptionForBeginningInitialLoad() {
        // swiftlint:disable:next line_length
        let expected = "The Eurofurence app is intended to remain fully functional while offline. To do this; we need to download a few megabytes of data. This may take several minutes depending upon the speed of your connection."
        
        XCTAssertEqual(expected, context.page.capturedPageDescription)
    }

    func testShouldShowTheInformationImageForBeginningInitialLoad() {
        XCTAssertEqual(context.assets.initialLoadInformationAsset, context.page.capturedPageImage)
    }

    func testShouldShowThePrimaryActionButtonForTheInitiateDownloadTutorialPage() {
        XCTAssertTrue(context.page.didShowPrimaryActionButton)
    }

    func testShouldTellTheTutorialPageToShowTheBeginDownloadTextOnThePrimaryActionButton() {
        XCTAssertEqual("Begin Download", context.page.capturedPrimaryActionDescription)
    }

    func testTappingThePrimaryButtonTellsTutorialDelegateTutorialFinished() {
        context.page.simulateTappingPrimaryActionButton()
        XCTAssertTrue(context.delegate.wasToldTutorialFinished)
    }

    func testTappingThePrimaryButtonTellsTutorialCompletionProvidingToMarkTutorialAsComplete() {
        context.page.simulateTappingPrimaryActionButton()
        XCTAssertTrue(context.tutorialStateProviding.didMarkTutorialAsComplete)
    }

    func testTappingThePrimaryButtonDoesNotTellAlertRouterToShowAlert() {
        context.page.simulateTappingPrimaryActionButton()
        XCTAssertFalse(context.alertRouter.didShowAlert)
    }

}
