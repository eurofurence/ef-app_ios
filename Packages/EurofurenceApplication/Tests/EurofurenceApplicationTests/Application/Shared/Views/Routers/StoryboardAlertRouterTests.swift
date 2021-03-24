import ComponentBase
import EurofurenceApplication
import EurofurenceModel
import UIKit
import XCTComponentBase
import XCTest

class StoryboardAlertRouterTests: XCTestCase {

    var capturingViewController: CapturingViewController!
    var alertRouter: AlertRouter!

    override func setUp() {
        super.setUp()

        capturingViewController = CapturingViewController()
        let window = UIWindow(frame: .zero)
        window.rootViewController = capturingViewController
        alertRouter = WindowAlertRouter(window: window)
    }

    func testPresentingAlertShouldShowAlertControllerWithAlertStyleOntoRootViewController() {
        alertRouter.show(Alert(title: "", message: ""))
        XCTAssertEqual(capturingViewController.capturedPresentedAlertViewController?.preferredStyle, .alert)
    }

    func testPresentingAlertShouldShowAlertControllerWithAnimation() {
        alertRouter.show(Alert(title: "", message: ""))
        XCTAssertTrue(capturingViewController.animatedTransition)
    }

    func testPresentingAlertShouldSetTheTitleOntoTheAlertController() {
        let expectedTitle = "Title"
        alertRouter.show(Alert(title: expectedTitle, message: ""))

        XCTAssertEqual(expectedTitle, capturingViewController.capturedPresentedAlertViewController?.title)
    }

    func testPresentingAlertShouldSetTheMessageOntoTheAlertController() {
        let expectedMessage = "Message"
        alertRouter.show(Alert(title: "", message: expectedMessage))

        XCTAssertEqual(expectedMessage, capturingViewController.capturedPresentedAlertViewController?.message)
    }

    func testPresentingAlertWithActionShouldAddActionWithActionTitle() {
        let expectedActionTitle = "Action"
        alertRouter.show(Alert(title: "", message: "", actions: [AlertAction(title: expectedActionTitle)]))
        let firstAction = capturingViewController.capturedPresentedAlertViewController?.actions.first

        XCTAssertEqual(expectedActionTitle, firstAction?.title)
    }

    func testPresentingAlertWithMultipleActionsShouldAddActionsInTheOrderTheyAreGiven() {
        let firstActionTitle = "First action"
        let secondActionTitle = "Second action"
        alertRouter.show(Alert(title: "",
                              message: "",
                              actions: [AlertAction(title: firstActionTitle),
                                        AlertAction(title: secondActionTitle)]))

        let actions = capturingViewController.capturedPresentedAlertViewController?.actions

        XCTAssertEqual(firstActionTitle, actions?.first?.title)
        XCTAssertEqual(secondActionTitle, actions?.last?.title)
    }

    func testWhenPresentationCompletesTheHandlerIsInvoked() {
        var alert = Alert(title: "", message: "")
        var invoked = false
        alert.onCompletedPresentation = { _ in invoked = true }
        alertRouter.show(alert)
        capturingViewController.capturedPresentationCompletionHandler?()

        XCTAssertTrue(invoked)
    }

    func testPresentationCompletedHandleNotInvokedUntilCompletionHandlerRan() {
        var alert = Alert(title: "", message: "")
        var invoked = false
        alert.onCompletedPresentation = { _ in invoked = true }
        alertRouter.show(alert)

        XCTAssertFalse(invoked)
    }

    func testDismissingDismissableTellsRootControllerToDismissPresentedController() {
        var alert = Alert(title: "", message: "")
        var dismissable: AlertDismissable?
        alert.onCompletedPresentation = { dismissable = $0 }
        alertRouter.show(alert)
        capturingViewController.capturedPresentationCompletionHandler?()
        dismissable?.dismiss()

        XCTAssertTrue(capturingViewController.didDismissPresentedController)
    }

    func testRootControllerDoesNotInvokeDismissalUntilToldTo() {
        var alert = Alert(title: "", message: "")
        alert.onCompletedPresentation = { _ in }
        alertRouter.show(alert)
        capturingViewController.capturedPresentationCompletionHandler?()

        XCTAssertFalse(capturingViewController.didDismissPresentedController)
    }

    func testDismissingAlertsUseAnimations() {
        var alert = Alert(title: "", message: "")
        var dismissable: AlertDismissable?
        alert.onCompletedPresentation = { dismissable = $0 }
        alertRouter.show(alert)
        capturingViewController.capturedPresentationCompletionHandler?()
        dismissable?.dismiss()

        XCTAssertTrue(capturingViewController.didDismissUsingAnimations)
    }

    func testDismissingAlertsInvokesHandlerOnCompletion() {
        var alert = Alert(title: "", message: "")
        var dismissable: AlertDismissable?
        alert.onCompletedPresentation = { dismissable = $0 }
        alertRouter.show(alert)
        capturingViewController.capturedPresentationCompletionHandler?()
        var invoked = false
        dismissable?.dismiss { invoked = true }
        capturingViewController.capturedDismissalCompletionHandler?()

        XCTAssertTrue(invoked)
    }

    func testDismissingAlertDoesNotInvokeHandlerUntilDismissalFinishes() {
        var alert = Alert(title: "", message: "")
        var dismissable: AlertDismissable?
        alert.onCompletedPresentation = { dismissable = $0 }
        alertRouter.show(alert)
        capturingViewController.capturedPresentationCompletionHandler?()
        var invoked = false
        dismissable?.dismiss { invoked = true }

        XCTAssertFalse(invoked)
    }

    func testWhenRootControllerHasPresentedSomethingThePresentedControllerIsToldToPresentAlert() {
        let presented = CapturingViewController()
        capturingViewController._presentedViewController = presented
        alertRouter.show(Alert(title: "", message: ""))

        XCTAssertNotNil(presented.capturedPresentedAlertViewController)
    }

    func testWhenRootControllerHasPresentedSomethingDismissingTheAlertShouldDismissItOnThePresentedController() {
        let presented = CapturingViewController()
        capturingViewController._presentedViewController = presented
        var dismissable: AlertDismissable?
        var alert = Alert(title: "", message: "")
        alert.onCompletedPresentation = { dismissable = $0 }
        alertRouter.show(alert)
        presented.capturedPresentationCompletionHandler?()
        dismissable?.dismiss()

        XCTAssertTrue(presented.didDismissPresentedController)
    }

}
