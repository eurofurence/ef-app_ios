//
//  StoryboardAlertRouterTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest
import UIKit

class CapturingViewController: UIViewController {

    private(set) var capturedPresentedAlertViewController: UIAlertController?
    private(set) var animatedTransition = false
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        capturedPresentedAlertViewController = viewControllerToPresent as? UIAlertController
        animatedTransition = flag
    }

}

class StoryboardAlertRouterTests: XCTestCase {

    var capturingViewController: CapturingViewController!
    var alertRouter: AlertRouter!

    override func setUp() {
        super.setUp()

        capturingViewController = CapturingViewController()
        let window = UIWindow(frame: .zero)
        window.rootViewController = capturingViewController
        alertRouter = StoryboardRouters(window: window).alertRouter
    }
    
    func testPresentingAlertShouldShowAlertControllerWithAlertStyleOntoRootViewController() {
        alertRouter.showAlert(title: "", message: "")
        XCTAssertEqual(capturingViewController.capturedPresentedAlertViewController?.preferredStyle, .alert)
    }

    func testPresentingAlertShouldShowAlertControllerWithAnimation() {
        alertRouter.showAlert(title: "", message: "")
        XCTAssertTrue(capturingViewController.animatedTransition)
    }

    func testPresentingAlertShouldSetTheTitleOntoTheAlertController() {
        let expectedTitle = "Title"
        alertRouter.showAlert(title: expectedTitle, message: "")

        XCTAssertEqual(expectedTitle, capturingViewController.capturedPresentedAlertViewController?.title)
    }

    func testPresentingAlertShouldSetTheMessageOntoTheAlertController() {
        let expectedMessage = "Message"
        alertRouter.showAlert(title: "", message: expectedMessage)

        XCTAssertEqual(expectedMessage, capturingViewController.capturedPresentedAlertViewController?.message)
    }

    func testPresentingAlertWithActionShouldAddActionWithActionTitle() {
        let expectedActionTitle = "Action"
        alertRouter.showAlert(title: "", message: "", actions: AlertAction(title: expectedActionTitle))
        let firstAction = capturingViewController.capturedPresentedAlertViewController?.actions.first

        XCTAssertEqual(expectedActionTitle, firstAction?.title)
    }

    func testPresentingAlertWithMultipleActionsShouldAddActionsInTheOrderTheyAreGiven() {
        let firstActionTitle = "First action"
        let secondActionTitle = "Second action"
        alertRouter.showAlert(title: "",
                              message: "",
                              actions: AlertAction(title: firstActionTitle),
                                       AlertAction(title: secondActionTitle))

        let actions = capturingViewController.capturedPresentedAlertViewController?.actions

        XCTAssertEqual(firstActionTitle, actions?.first?.title)
        XCTAssertEqual(secondActionTitle, actions?.last?.title)
    }
    
}
